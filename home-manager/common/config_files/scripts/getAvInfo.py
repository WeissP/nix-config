#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.lxml python3Packages.cfscrape python3Packages.cloudscraper 

from lxml import etree
import requests
import os
import re
import time
import cfscrape
import cloudscraper

backupPath = "/home/weiss/backup/avList.txt"
avPath = '/run/media/weiss/Seagate_Backup/videos/porn/'
avTestPath = '/run/media/weiss/Seagate_Backup/porn/test'


def cookie_to_dict(cookie):
    cookie_dict = {}
    items = cookie.split(';')
    for item in items:
        key = item.split('=')[0].replace(' ', '')
        value = item.split('=')[1]
        cookie_dict[key] = value
    return cookie_dict


def getHtml(url):
    scraper = cloudscraper.create_scraper()
    # scraper = cfscrape.create_scraper()
    headers = {
        'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36'
    }
    cookies = {
        'cookie':
        '__qca=P0-429543338-1584707968936; timezone=-120; userid=weissp; session=L5w5UOOmNd0J5LTkt1zNspqpUvPA%2FPpXxmqdsgSk%2BSD%2F%2BeQGsU9WwV2s4qZV3C9h2HIKrP3OUB9f6aQoNEZJ0A%3D%3D+%3B+7c8f6a26f66f673a66d0ff132f9714e131958b5b+%3B+-65536; __cfduid=d639399b2468b189873bbf8ae55883a451587318204; cf_clearance=40a70cb8950cfc5a0f883c8005781d6d0d724cf8-1588368008-0-150; __cf_bm=22a31bea7258d81c75cb3c1e11085cbbc44bee96-1588368011-1800-AbG33FU81JPWgYsPc7thJLu43UYQNL8NNn/2bFV7cew4F3eg3pQRKSGpRs440FAKT2D6sJyr60pNWPjPqcgXlQ9YkobTUhi1zOcfhhikDY4h'
    }
    cookie = "__qca=P0-429543338-1584707968936; timezone=-120; userid=weissp; session=L5w5UOOmNd0J5LTkt1zNspqpUvPA%2FPpXxmqdsgSk%2BSD%2F%2BeQGsU9WwV2s4qZV3C9h2HIKrP3OUB9f6aQoNEZJ0A%3D%3D+%3B+7c8f6a26f66f673a66d0ff132f9714e131958b5b+%3B+-65536; __cfduid=d639399b2468b189873bbf8ae55883a451587318204; cf_clearance=4c66ea20a6b72c85b880525cafba5ba999d9e481-1589147887-0-150; __cf_bm=81dc767e8834ba72d9d730709ad02c67471e63f9-1589147890-1800-AWWLy4bCnupVVg/zM2BjeLxMcTx28pS4HwSG+8voVPXzKlIyNi1N26q7LelJY/OKrTqBbuKC1fB4ucFFt/zLcNfYx2q1kQGc/c2jbzWG2/8k"
    # html = requests.get(url, cookies = cookie_to_dict(cookie), headers = headers)
    html = requests.get(url, cookies = cookie_to_dict(cookie), headers = headers)
    html = scraper.get(url, headers=headers)
    # print(etree.HTML(html.text))
    return etree.HTML(html.text)


def getAvInfo(html):
    tag = html.xpath('//div[@id="video_genres"]//span/a/text()')
    cast = html.xpath('//div[@id="video_cast"]//span[@class="star"]/a/text()')
    # print(tag + cast)
    if len(cast) > 1:
        gruppenSexTag = ",GruppenSex,"
    else:
        gruppenSexTag = ""
    if tag and cast:
        return "【%s】%s %s" % ("、".join(cast), ",".join(tag), gruppenSexTag)
    else:
        return ""


def avCodeTest(avCode):
    url = 'https://www.javlibrary.com/cn/vl_searchbyid.php?keyword=%s' % avCode
    # print(url)
    html = getHtml(url)
    # print(html.text)
    avInfo = getAvInfo(html)
    # print(avInfo)
    if avInfo:
        return avInfo
    else:  # AvCode error or more than one search results
        try:
            avId = html.xpath('//div[@class="videos"]/div[1]/@id')[0]
        except:
            return ""
        newUrl = "http://www.javlibrary.com/cn/?v=%s" % avId.replace(
            "vid_", "")
        newHtml = getHtml(newUrl)
        newAvInfo = getAvInfo(newHtml)
        if newAvInfo:
            return newAvInfo
        else:
            return ""


def backupAvList(avPath, backupPath):
    with open(backupPath, 'w') as f:
        f.write("\n".join(os.listdir(avPath)))


def rename(avPath):
    fileList = os.listdir(avPath)
    n = 0
    for i in fileList:
        # time.sleep(0.2)
        fileName = fileList[n]
        n += 1
        if re.search(r"fertig", fileName):
            continue
        print(fileName)
        if fileName == "subtitles":
            continue
        fileNameFilter = fileName.replace("hjd", "").replace(
            "carib", "").replace(".com", "").replace("1pon", "").replace(
                "1pondo",
                "").replace("gg999", "").replace("play999", "").replace(
                    "luxu", "").replace("fun2048", "").replace("one2048", "").replace("hhd800", "")
        avCode = re.search(r"[a-zA-Z]{2,5}-?\d{3,5}", fileNameFilter)
        oldName = os.path.join(avPath, fileName)
        if avCode:
            avCode = avCode.group(0)
            avInfo = avCodeTest(avCode)
            print(avCode + avInfo)
            if avInfo:
                newName = os.path.join(
                    avPath,
                    avInfo + avCode + "fertig" + os.path.splitext(fileName)[1])
            else:
                newName = os.path.splitext(
                    oldName)[0] + "fertig" + os.path.splitext(oldName)[1]
        else:
            newName = os.path.splitext(
                oldName)[0] + "fertig" + os.path.splitext(oldName)[1]
        os.rename(oldName, newName)


rename(avPath)
backupAvList(avPath, backupPath)

# getHtml(r"http://www.javlibrary.com/cn/?v=javli63f6y")
