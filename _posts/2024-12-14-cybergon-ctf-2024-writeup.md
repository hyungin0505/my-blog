---
title: "[CyberGon CTF 2024] Writeup"
description: 2025 CyberGon CTF Writeup (Osint, Stegano, Crypto, Reconnaissance)
date: 2024-12-14 13:26:00 +0900
categories: [Security, CTF]
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

![Image](https://blog.kakaocdn.net/dna/CFjE3/btsLiuvrb2x/AAAAAAAAAAAAAAAAAAAAAHoYW4DqfBmU38QHwFKfF1ce0D_P5pF-Mn1HtvYWJ8EQ/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=qH3NMTwBk2Di7sQt9CEMv7yXB9E%3D)

다른 분야는 어려워서 못 풀었고 그냥 Osint, Stegano, Crypto, Reconnaissance 풀어봤다.  

**OSINT**  
Favorite Journal  
The Statue   
Vacation(1)  

**STEGANO**  
Truesight  

**Crypto**  
RSA1  

**Reconnaissance**  
Secure Life  

<br>

---

### OSINT

#### Favorite Journal

![Image](https://blog.kakaocdn.net/dna/Z5fwU/btsK26gKbEo/AAAAAAAAAAAAAAAAAAAAAGUlrK68c5QRCHhLerKtE0isFUsHphcaQUxUrNyGjOFW/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=a%2F1WktkX%2Bzquf4JT7wCjp4hKPjs%3D)

저널 맨 앞 페이지 사진이다.  

<br>

---

<https://www.learnbig.net/th/books/shwe-thway-vol-45-no-15/>

구글 렌즈로 번역해보면 'Shwe Thway Vol. 45 and No.15' 가 나온다.  
이 저널 1권 1호의 출판일, 출판사 번호를 알아내야 한다.   

<br>

---

<https://sites.google.com/view/haytha-yu-mon/shwe-thway-vol-01-1969>  

여기서 pdf 스캔 파일을 찾을 수 있다.  

 

<br>

---

![Image](https://blog.kakaocdn.net/dna/dleES8/btsK3tW5Nnw/AAAAAAAAAAAAAAAAAAAAAPNNSGlDTopocc4odWsSwSO7HBznadrsWAtz_f9eUTUc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=HuejLgmtUga8ptBRC8IT%2FwNns4A%3D)

1권 1호의 표지이다.  
왼쪽 위에 출판일이 적혀있는데 구글 번역기로는 인식이 잘 되지 않아서 직접 글자 찾아가면서 번역했다.  

1969년 4월 1일에 출판되었다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/cTMSnX/btsK4MuDKdN/AAAAAAAAAAAAAAAAAAAAAAZHrZ8thJPOQBpCjoN34zkMJW4F25OU_pek-F4gL3Vr/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=KTDC6jo9RZKmgjC1pMSCU3rWozE%3D)

마지막 페이지에는 출판사 정보가 적혀 있다.  

구글 이미지 번역으로 보면 'Temple of Literature Printing House'에서 출판되었다고 한다.  
출판사 번호는 0032이다.  


`CYBERGON_CTF2024{4-1-69_0032}` 

<br>

---

#### The Statue

![Image](https://blog.kakaocdn.net/dna/cQ186m/btsK2wm1vou/AAAAAAAAAAAAAAAAAAAAAGFSFCxL-sqW7FvCnUwdlevXJQWBzyVP5VBfLAKQgDJB/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=jMr2IIfbZosXQnwxaIs%2BmZJxr10%3D)

동상 사진이 주어진다.  
구글 렌즈로 쉽게 어디인지 찾을 수 있다.  


<br>

---

![Image](https://blog.kakaocdn.net/dna/47OCs/btsK4PdR3Sg/AAAAAAAAAAAAAAAAAAAAAENWJhcKSpSO1cQgeHgvESIZFcv4rZNKAkmqW7ZitR0Z/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=E0BwlvJ6p8lIPOQjCaLdZJHKpYI%3D)

'Maha Boohi Ta Htaung Standing Buddha' 라는 이름의 장소이다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/4GexV/btsK4vzWvJo/AAAAAAAAAAAAAAAAAAAAAGg6D9n4YB_gwEvCJl3Wd_OWW4rzlKHJmO6ixumMyFOS/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=PwKVbkEkoDRLy4%2BWd%2Bmx5nkSKak%3D)![Image](https://blog.kakaocdn.net/dna/PeX6j/btsK2C1ynHl/AAAAAAAAAAAAAAAAAAAAABXfLQYVT4WUmF_shbNs1MnBhbt9irJoE0JmQA9oNQ_W/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=HEIaodTcvrvC1GPd6OOaCNABzA4%3D)

동상 앞에는 3개의 정사각형 타일들이 보인다.  
카메라 각도를 보아 네 블럭 정도 떨어진 곳의 좌표는 `22.0801` `95.2885`이다.  

`CYBERGON_CTF2024{22.0801_95.2885}`

<br>

---

#### Vacation (1)

![Image](https://blog.kakaocdn.net/dna/bdtgH3/btsK4QDRDLN/AAAAAAAAAAAAAAAAAAAAAGz0V-YTsZ-NgFy1X4IcwuyDDl90enWws06xKpeeM03s/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=To16cGcMIp8DzPbR6uQT51tOeqo%3D)

`png` 파일이 주어졌지만 열리지 않는다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/pH6xy/btsK2BIqpx0/AAAAAAAAAAAAAAAAAAAAACZDstTxuBJ68mlT1Ipvwe0EAMlmesQfC_5Svf_DMHmQ/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=hzCkC2FdgJNytAN9K9Kslxk%2B9GQ%3D)

010Editor로 열어보면 `ftyp`라는 문자열이 보이는 것으로 보아 `HEIC` 파일인 것을 알 수 있다.  
일반적으로 `HEIF` 이미지를 의미한다.  

갤럭시 폰으로 사진을 찍으면 `HEIF` 파일로 저장된다.  
하지만 윈도우 기본 사진 뷰어로는 열 수 없다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/cweX3j/btsK22S1SZ6/AAAAAAAAAAAAAAAAAAAAALmzBm8Xz9u5DcmciTnfVifIqVC3KXNa-VARQSN3Ld1T/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=BYsLhIV9WrcZ2UXuknxCCgjXEiE%3D)

`HEIF` to `PNG` 변환기를 이용해서 변환하면 이미지 파일을 볼 수 있다.  
구글 렌즈를 통해서 베트남의 `Ha Long` 인근인 것을 알 수 있다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/dh3yvQ/btsK3fY734w/AAAAAAAAAAAAAAAAAAAAALYnxfSky0BF3pH4O6AZiAd38EXiYGEedeEmh214HIbR/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=z0iJYK%2BeQho4bRBNWIml7Kb9kZ0%3D)

관람차의 각도와 롤러코스터 레일이 있다는 정보를 통해서 힌트를 얻을 수 있다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/IJm6l/btsK2wtPkn9/AAAAAAAAAAAAAAAAAAAAANFnLm6GDPmB9TrB81zSMx1b5MTryvAWwq9dDBjpqv-s/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=uoBAP%2FPNqesyyWXLe4c%2FP3UI278%3D)

사진이 찍힌 것으로 보이는 두 빌딩이 있는데 왼쪽에서 찍힌 듯 하다.  
두 건물 모두 같은 호텔인데 호텔 이름은 'Muong Thanh Luxury Ha Long Centre Hotel'이다.  

`CYBERGON_CTF2024{Muong Thanh Luxury Ha Long Centre Hotel, Ha Long, Vietnam}`

<br>

---

### STEGANO

#### Truesight

![Image](https://blog.kakaocdn.net/dna/T4LYe/btsK2BBHJe4/AAAAAAAAAAAAAAAAAAAAAJxVxEJMjlIMhVwMf24nANZ_zWfI3-XoCWDGG7dxyFsL/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=4aRbTE2bVlyhbQeahp13mWVQYIo%3D)

`PNG` 파일이 주여졌는데 열리지 않는다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bfD2kZ/btsK4wZZ7HX/AAAAAAAAAAAAAAAAAAAAAFH-JeRnvIlvfQQlA-xeyaFAtnVYCrQt-0WKE8Ybbthn/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=gVB4AT1iNRpNxnUOnYlm5e5qbHk%3D)

헥스를 뜯어보면 `IDHR`, `RGB` 같은 `PNG` 파일 포맷에 들어가는 단어들이 있는 것을 볼 수 있는데 파일 시그니처가 없는 것을 알 수 있다.  

`PNG` 파일 시그니처는 `89 50 4E 47 0D 0A 1A 0A`이다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/cdvHLf/btsK4sXCpP7/AAAAAAAAAAAAAAAAAAAAAOCIVio-nFOcZGWiuxLJhPnCE0Ew3VSyX8gOLpHl0iqU/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=astoPTKfL3j42Q0YfuMrBS58r3k%3D)![Image](https://blog.kakaocdn.net/dna/lXNjs/btsK34bQ1lm/AAAAAAAAAAAAAAAAAAAAAJwW1XBGQeoD8wcNnvbzGbq_-R2wCIsggMQQ4EzgZTgt/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=PfJNmopXuhh21w3THEEP0srOuKs%3D)

파일 시그니처를 올바르게 집어넣고 다시 이미지를 열어보면 플래그와 함께 원본 이미지를 얻을 수 있다.  

`CYBERGON_CTF2024{y0u_g07_7h3_r!gh7_s1gn5}`  

<br> 

---

### CYRPTO

#### RSA1

```python
# crypto.py

from Crypto.Util.number import getPrime, bytes_to_long
from math import gcd

flag = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
FLAG = flag.encode()

out = open('output.txt', 'w')

rsa_q = getPrime(512)
rsa_p = getPrime(512)   
n = rsa_q * rsa_p
exp1 = 0x10003 #65539
exp2 = 0x10001 #65537

assert gcd(exp1, exp2) == 1
assert gcd(exp1, n) == 1
assert gcd(exp2, n) == 1

    
def encryption(plaintext):
    cip1 = pow(plaintext, exp1, n)
    cip2 = pow(plaintext, exp2, n)
    return (cip1, cip2)

cip1, cip2 = encryption(bytes_to_long(FLAG))

out.write("n = "+ str(n)+ "\ncip1 = "+ str(cip1)+ "\ncip2 = "+str(cip2))
out.close()
```

---

```python
from Crypto.Util.number import inverse, long_to_bytes

n = 157508528276758767638734754424621334466394815259243977959210580239577661657714722726225362774231543920376913579658052494826650164280151836289734452590647102313381584133512835595817708427222746495824286741840967127393187086028742577763080469063534742728547285121808241078515099307495843605080694383425986909029
cip1 = 69950256754119187070741220414057295159525964023691737870808579797990094306696842507546591858691032981385348052406246203530192324935867616305070637936848926878022662082401090988631324024964630729510728043900454511012552105883413265919300434674823577232105833994040714469215427142851489025266027204415434792116
cip2 = 26975575766224799967239054937673125413993489249748738598424368718984020839138611191333159231531582854571888911372230794559127658721738810364069579050102089465873134218196672846627352697187584137181503188003597560229078494880917705349140663228281705408967589237626894208542139123054938434957445017636202240137
e1 = 65539
e2 = 65537

def extended_gcd(a, b):
    if b == 0:
        return a, 1, 0
    g, x1, y1 = extended_gcd(b, a % b)
    x = y1
    y = x1 - (a // b) * y1
    return g, x, y

_, x, y = extended_gcd(e1, e2)

m1 = pow(cip1, x, n)
m2 = pow(cip2, y, n)
m = (m1 * m2) % n

flag = long_to_bytes(m)
print("FLAG:", flag.decode())
```

`CYBERGON_CTF2024{54m3_m0Du1u5!!!!!}`

<br>

---

#### Chill Bro

![Image](https://blog.kakaocdn.net/dna/tOuSx/btsK3mYFxcI/AAAAAAAAAAAAAAAAAAAAAMRTauZXx1FEX8FhD6Whd-D74gRCsUs8QO2Y2kCk8jZ0/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=6NRqCl25cMbXKpTtj99JpG7EirM%3D)

졸라맨들이 있는 사진이 주어진다.  
각 자세와 닮은 알파벳들을 나열하는 건가 싶었는데 하다가 포기했다..   

2023 CyberGon CTF 라이트업 읽어보는데 [dCode](https://www.dcode.fr/) 사이트에 굉장히 많은 기호 Cipher 종류가 있길래 거기서 한번 찾아봤다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bWLQ8Q/btsK4KqMa5x/AAAAAAAAAAAAAAAAAAAAANdJfaVeqn_SF0bo4tDKi80JSz9fSolqMpfNDyrdNiVo/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=CC53FzVD1Z8ah0ScdfpxT9JYDs4%3D)

Dancing Men Decoder를 찾아냈고 거기에 돌려서 플래그를 얻었다.  

`CYBERGON_CTF2024{TAKEABREAKBROLETSDANCE}`

<br>

---

### Reconnaissance

#### Secure Life

`certificate.der`{: .filepath} 파일이 주어진다.  

처음 보는 파일 포맷이라 뭔가 했는데 인증서 파일이다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/Hnw1X/btsK33xIvtb/AAAAAAAAAAAAAAAAAAAAAFwxfnx4_FjTGC9Zpw2Lg7Vl62p4mfOvNM4dfQE56tW2/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=%2FIq%2BCQWyux1iy0QeW7pbVkLOQCs%3D)![Image](https://blog.kakaocdn.net/dna/cUMnEC/btsK5FhOZDw/AAAAAAAAAAAAAAAAAAAAAJ7ZnuENFkJkCdQf4IEO2z3ACxFH02iEmhz7ZwoFFLsJ/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=H1Pwmj3Gd97aeOPxL0pFu4vY%2BxU%3D)

그냥 윈도우에서 더블 클릭으로 열어도 만료일시가 나오긴 한다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/dA1Ux0/btsK3gqL8je/AAAAAAAAAAAAAAAAAAAAAFPj346BSMkLAzH8R4rv5jBIZiSRu9JpYL4ZMnVR0T6m/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=CyTdd5F6Q%2FfHIAGk6swHlyQXd1Q%3D)

문제 풀 때는 당연히 안 되겠거니 하고 그냥 [사이트](https://pkitools.net/)에서 돌렸다.  

`CYBERGON_CTF2024{2039:11:24:20:38:00}`

<br>

---

엄청 오랜만에 CTF 풀어봤다  
반수하다 오니까 감이 다 뒤진 것 같다;;  
괜히 했나.. 1년간 변화가 없다  

웹이고 포렌식이고 분야도 다양하고 문제도 되게 많아서 많이 시도해봤는데 될 것 같으면서도 안 되는게 많았다  
결국 하나도 못 풀었는데 끝나고 디코에서 사람들 하는 얘기 들어보니까 너무 허무하게 풀리는 것들이었다  
대부분 플래그 얻기 바로 전 단계에서 막혀서 좀 아쉬웠다   
