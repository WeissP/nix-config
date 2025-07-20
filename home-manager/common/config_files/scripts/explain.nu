export def explain_word [word: string, context: string] {
   ^llm -m "gpt-4.1" $"你是一个知识渊博的语言导师，专门研究词汇和语境含义，提供贴切的例子和清晰的解释。你要通过将特定词汇与特定语境联系起来进行解释，帮助用户理解其在该场景中的含义和用法。请提供清晰的定义以及任何可能适用的相关内涵。除此以外，如果这个词汇有其他常见的含义，请一并介绍。如果有的话，介绍这个词语的由来和与它相近或易混淆的词汇。注意，易混淆词指的是与该单词拼写非常接近的词，但却具有其他含义。 
语境：($context)
词汇：($word)
模板：
        含义：<在给定上下文中的含义……>
        翻译：<整段 context 的翻译……>
        其他含义：……（可选，没有则跳过）
        由来：……（可选，没有则跳过）
        易混淆词：……（可选，没有则跳过）
"
}

export def main [
    word: string,
    # The context to explain the word in. If empty, defaults to the word itself.
    --context: string,
    # The source of the context. If empty, defaults to "daily".
    --source: string = "daily",
    # The directory to save the explanation to. If set, the explanation is saved to a file.
    --save-dir: string,
    # The filename to save the explanation to. Can be a full path if --save-dir is not set.
    --save-file: string
] {
    let context = if ($context | is-empty) { $word } else { $context }
    let explanation = explain_word $word $context
    let timestamp = date now | format date '%Y%m%d_%H%M%S'

    if ($save_dir | is-not-empty) or ($save_file | is-not-empty) {
        let file_path = if ($save_dir | is-empty) {
            $save_file
        } else {
            let filename = if ($save_file | is-empty) {
                $"($word)--($timestamp).yaml"
            } else {
                $save_file 
            }
            $save_dir | path join $filename
        }
        mkdir ($file_path | path dirname)
        { word: $word, context: $context, explanation: $explanation, timestamp: $timestamp, source: $source}
        | to yaml
        | save -f $file_path
    }

    $explanation
}
 
export def export_to_anki [--dir: string = "/home/weiss/Documents/words"] {
    cd $dir
    ls *.yaml -f
        | get name
        | each {open}
        | flatten 
        | each {|it| 
            let dt = ($it.timestamp | into datetime -f '%Y%m%d_%H%M%S')
            {
                word: $it.word,
                context: ($it.context | str replace --all $it.word $"<strong>($it.word)</strong>"),
                explanation: ($it.explanation | str replace --all "\n" $"<br>"),
                timestamp_human: ($dt | format date '%Y-%m-%d %H:%M:%S'),
                unix_timestamp: ($dt | into int),
                source: "And then there were none" 
                # source: ($it.source | default "And then there were none") 
            }
        }
        | to csv --noheaders --separator ";"
        | save -f ($dir | path join "anki.csv")
   cd -
}

