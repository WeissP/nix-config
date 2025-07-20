const qfmt = "\n<div class=\"card-front\">\n  \n<div class=\"card-header\">\n  <div class=\"brand\">FluentAI <span class=\"brand-x\">x</span> Anki</div>\n  <div class=\"header-right\">\n    \n<a href=\"https://fluentai.pro/app/notebook\" target=\"_blank\" class=\"notebook-button\">\n  Notebook\n</a>\n\n  </div>\n</div>\n\n  <div class=\"card-content\">\n<div class=\"translation-container\">\n  <div class=\"translation\">{{Translation}}</div>\n  {{#Transliteration}}\n  <div class=\"transliteration\">{{Transliteration}}</div>\n  {{/Transliteration}}\n</div>\n\n      \n      <div class=\"audio-container\">{{Audio}}</div>\n      \n      \n{{#Context}}\n<div class=\"context-container\">\n  <div class=\"context\">{{Context}}</div>\n</div>\n{{/Context}}\n\n  </div>\n</div>\n\n<style>\n\n/* Base styles inspired by Tailwind */\n* {\n  margin: 0;\n  padding: 0;\n  box-sizing: border-box;\n  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;\n}\n\n.card-front, .card-back {\n  background-color: hsl(240 10% 12%);\n  color: hsl(0 0% 98%);\n  min-height: 100vh;\n  display: flex;\n  flex-direction: column;\n  border-radius: 0.5rem;\n  overflow: hidden;\n  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);\n}\n\n\n.card-header {\n  display: flex;\n  justify-content: space-between;\n  align-items: center;\n  padding: 1em 1.5em;\n  background-color: hsl(240 5.9% 10%);\n  border-bottom: 1.5px solid hsl(240 3.7% 15.9%);\n}\n\n.brand {\n  font-weight: bold;\n  font-size: 1.25em;\n  color: white;\n}\n\n.brand-x {\n  font-weight: normal;\n  opacity: 0.7;\n  margin: 0 0.25em;\n}\n\n.header-right {\n  display: flex;\n  align-items: center;\n  gap: 1em;\n}\n\n\n.notebook-button {\n  display: inline-flex;\n  align-items: center;\n  justify-content: center;\n  padding: 0.5em 1em;\n  border-radius: 0.5rem;\n  font-weight: 500;\n  font-size: 0.875em;\n  text-decoration: none;\n  white-space: nowrap;\n  transition-duration: 150ms;\n  transition-timing-function: ease-in-out;\n  border: 1px solid hsl(240 3.7% 15.9%);\n  background-color: hsl(240 5.1% 14.9%);\n  color: white;\n  cursor: pointer;\n}\n\n.notebook-button:hover {\n  border-color: #8B5CF8;\n}\n\n\n.card-content {\n  flex: 1;\n  display: flex;\n  flex-direction: column;\n  padding: 2em;\n  text-align: left;\n}\n\n.learning-value {\n  font-size: 1.75em;\n  line-height: 1.5;\n  max-width: 100%;\n  word-wrap: break-word;\n  margin-bottom: 0.5em;\n}\n\n.front-content {\n  margin-bottom: 1.5em;\n}\n\n\n.translation-container {\n  margin-bottom: 1.5em;\n}\n\n.translation {\n  font-size: 1.5em;\n  font-weight: 500;\n  color: hsl(160 60% 45%);\n  margin-bottom: 0.5em;\n  word-wrap: break-word;\n}\n\n.transliteration {\n  font-size: 1.25em;\n  color: hsl(30 80% 55%);\n  font-style: italic;\n  margin-bottom: 1em;\n  word-wrap: break-word;\n}\n\n\n.context-container {\n  background-color: hsl(240 5.1% 14.9%);\n  padding: 1em;\n  border-radius: 0.5rem;\n  margin-top: 1em;\n  word-wrap: break-word;\n}\n\n.context {\n  font-size: 1.125em;\n  margin-bottom: 0.75em;\n  line-height: 1.5;\n}\n\n.context-translation {\n  font-size: 1em;\n  color: hsl(280 65% 60%);\n  font-style: italic;\n  line-height: 1.5;\n}\n\n\n.answer-divider {\n  height: 2px;\n  background: #8B5CF6;\n  margin: 1.5em 0;\n  border-radius: 1px;\n}\n\n\n.audio-container {\n  margin: 1em 0 1.5em;\n  display: flex;\n  justify-content: center;\n}\n\n</style>\n" 

const afmt = "\n<div class=\"card-back\">\n  \n<div class=\"card-header\">\n  <div class=\"brand\">FluentAI <span class=\"brand-x\">x</span> Anki</div>\n  <div class=\"header-right\">\n    \n<a href=\"https://fluentai.pro/app/notebook\" target=\"_blank\" class=\"notebook-button\">\n  Notebook\n</a>\n\n  </div>\n</div>\n\n  \n  <div class=\"card-content\">\n    <div class=\"front-content\">\n      <div class=\"learning-value\">{{LearningValue}}</div>\n    </div>\n    \n    <div class=\"answer-divider\"></div>\n    \n    <div class=\"answer-content\">\n      \n<div class=\"translation-container\">\n  <div class=\"translation\">{{Translation}}</div>\n  {{#Transliteration}}\n  <div class=\"transliteration\">{{Transliteration}}</div>\n  {{/Transliteration}}\n</div>\n\n      \n      <div class=\"audio-container\">{{Audio}}</div>\n      \n      \n{{#Context}}\n<div class=\"context-container\">\n  <div class=\"context\">{{Context}}</div>\n  {{#ContextTranslation}}\n  <div class=\"context-translation\">{{ContextTranslation}}</div>\n  {{/ContextTranslation}}\n</div>\n{{/Context}}\n\n  {{#Explanation}}\n  <div class=\"context-container\">{{Explanation}}</div>\n  {{/Explanation}}\n\n    </div>\n  </div>\n</div>\n\n<style>\n\n/* Base styles inspired by Tailwind */\n* {\n  margin: 0;\n  padding: 0;\n  box-sizing: border-box;\n  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;\n}\n\n.card-front, .card-back {\n  background-color: hsl(240 10% 12%);\n  color: hsl(0 0% 98%);\n  min-height: 100vh;\n  display: flex;\n  flex-direction: column;\n  border-radius: 0.5rem;\n  overflow: hidden;\n  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);\n}\n\n\n.card-header {\n  display: flex;\n  justify-content: space-between;\n  align-items: center;\n  padding: 1em 1.5em;\n  background-color: hsl(240 5.9% 10%);\n  border-bottom: 1.5px solid hsl(240 3.7% 15.9%);\n}\n\n.brand {\n  font-weight: bold;\n  font-size: 1.25em;\n  color: white;\n}\n\n.brand-x {\n  font-weight: normal;\n  opacity: 0.7;\n  margin: 0 0.25em;\n}\n\n.header-right {\n  display: flex;\n  align-items: center;\n  gap: 1em;\n}\n\n\n.notebook-button {\n  display: inline-flex;\n  align-items: center;\n  justify-content: center;\n  padding: 0.5em 1em;\n  border-radius: 0.5rem;\n  font-weight: 500;\n  font-size: 0.875em;\n  text-decoration: none;\n  white-space: nowrap;\n  transition-duration: 150ms;\n  transition-timing-function: ease-in-out;\n  border: 1px solid hsl(240 3.7% 15.9%);\n  background-color: hsl(240 5.1% 14.9%);\n  color: white;\n  cursor: pointer;\n}\n\n.notebook-button:hover {\n  border-color: #8B5CF8;\n}\n\n\n.card-content {\n  flex: 1;\n  display: flex;\n  flex-direction: column;\n  padding: 2em;\n  text-align: left;\n}\n\n.learning-value {\n  font-size: 1.75em;\n  line-height: 1.5;\n  max-width: 100%;\n  word-wrap: break-word;\n  margin-bottom: 0.5em;\n}\n\n.front-content {\n  margin-bottom: 1.5em;\n}\n\n\n.translation-container {\n  margin-bottom: 1.5em;\n}\n\n.translation {\n  font-size: 1.5em;\n  font-weight: 500;\n  color: hsl(160 60% 45%);\n  margin-bottom: 0.5em;\n  word-wrap: break-word;\n}\n\n.transliteration {\n  font-size: 1.25em;\n  color: hsl(30 80% 55%);\n  font-style: italic;\n  margin-bottom: 1em;\n  word-wrap: break-word;\n}\n\n\n.context-container {\n  background-color: hsl(240 5.1% 14.9%);\n  padding: 1em;\n  border-radius: 0.5rem;\n  margin-top: 1em;\n  word-wrap: break-word;\n}\n\n.context {\n  font-size: 1.125em;\n  margin-bottom: 0.75em;\n  line-height: 1.5;\n}\n\n.context-translation {\n  font-size: 1em;\n  color: hsl(280 65% 60%);\n  font-style: italic;\n  line-height: 1.5;\n}\n\n\n.answer-divider {\n  height: 2px;\n  background: #8B5CF6;\n  margin: 1.5em 0;\n  border-radius: 1px;\n}\n\n\n.audio-container {\n  margin: 1em 0 1.5em;\n  display: flex;\n  justify-content: center;\n}\n\n</style>\n"

const explanation_field = { name: "Explanation", ord: 8, font: "Liberation Sans", media: [], rtl: false, size: 18, sticky: false }

const fields_separator = ""

const apkg_name = "updated.apkg"

export def explain [flds: string] {
   let parsed = $flds | split row $fields_separator
   let context = $parsed.1
   let word = $parsed.3
   ^llm -m "gpt-4.1" $"你是一个知识渊博的语言导师，专门研究词汇和语境含义，提供贴切的例子和清晰的解释。你要通过将特定词汇与特定语境联系起来进行解释，帮助用户理解其在该场景中的含义和用法。请提供清晰的定义以及任何可能适用的相关内涵。除此以外，如果这个词汇有其他常见的含义，请一并介绍。如果有的话，介绍这个词语的由来和与它相近或易混淆的词汇。注意，易混淆词指的是与该单词拼写非常接近的词，但却具有其他含义。 
词汇：($word)
语境：($context)
模板：
        含义：< 在给定上下文中的含义……>
        其他含义：……（可选，没有则跳过）
        由来：……（可选，没有则跳过）
        易混淆词：……（可选，没有则跳过）
"  | str replace --all "\n" "<br>"
}

export def main [apkg: string] { 
   let dir = mktemp -d
   unzip -q $apkg -d $dir 
   let anki2 = $dir | path join "collection.anki2"
   stor import --file-name $anki2 

   stor open
     | query db "select id,flds from notes"
     | par-each {|row| {id: $row.id, fields: ($row.flds + $fields_separator + (explain $row.flds))}}
     | each {|r| {flds: $r.fields} | stor update --table-name notes --where-clause $"id = ($r.id)"}

   let old_models = stor open | query db "select models from col where id = 1" | get models | first | from json
   let key = $old_models | columns | first 
   let models = $old_models
     | update $key {|v| $v | get $key | update tmpls.0.afmt $afmt | update tmpls.0.qfmt $qfmt | upsert flds.8 $explanation_field}
     | to json --raw 
   stor update --table-name col --update-record {models: $models} --where-clause "id = 1"
   rm $anki2
   stor export --file-name $anki2
   let filenames = ls $dir | get name | str join  " "
   cd $dir
   ^zip -q $apkg_name *
   cd -
   cp ($dir | path join $apkg_name) $apkg_name
}


