---
title: 레이스 컨디션 (Race Condition) & ToCToU
description: 레이스 컨디션과 ToCToU 공격 기밥
date: 2025-01-30 04:13:00 +0900
categories: [Security, System Hacking]
tags: [race condition, toctoui]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

## 레이스 컨디션 (Race Condition)

두 개 이상의 프로세스 혹은 스레드가 공유 리소스(파일, 메모리 등)에 접근할 때, 실행 순서에 따라 예상하지 못한 결과가 발생하는 상황이다  
실행 순서가 올바르게 제어되지 않으면 오류나 보안 취약점이 발생할 수 있다  
<br>

---

### Dreamhack - Race with me?

[https://dreamhack.io/wargame/challenges/1675](https://dreamhack.io/wargame/challenges/1675)

레이스 컨디션으로 인해 발생할 수 있는 보안 취약점을 활용하는 문제이다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FEJIYq%2FbtsL1CsCgYL%2FpBHQ7eiIZCUp2PjgSzxAMk%2Fimg.png)

`Dockerfile`과 함께 `chall` 파일이 주어지는데 `stripped`되어 있다  
`stripped`를 `pwndbg`로 디버깅해보려 했는데 쉽지 않아서 그냥 IDA 돌렸다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbpaOVd%2FbtsL23wa2WW%2FGwRxtrs4AqNKu5fe9Kfsok%2Fimg.png)

메뉴 4개가 주어진다  
메뉴 설명을 통해서 대강 어떤 기능을 하는지 알 수 있다  

4는 바이너리를 종료한다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbTACVv%2FbtsL1GI0Zpu%2FsAznHAYmIOuMnjinPbllJK%2Fimg.png)

1로 `input`에 데이터를 입력할 수 있다  
2는 `pthread`로 새로운 스레드를 실행한다  
`corres` 변수가 `0xdeadbeef`와 일치하면 플래그를 출력해준다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FlXAAl%2FbtsL2IeLprn%2FPQGnoMwGVytTyUxsRQiwik%2Fimg.png)

2번 메뉴에서 생성된 스레드가 동작하는 함수이다  
10초가 지나면 `corres` 변수에 `input`으로 입력했던 값이 대입된다  

여기서 레이스 컨디션으로 인한 취약점이 있다  
새로운 스레드를 만들고 10초가 지나기 전에 메뉴 1을 통해서 `input` 값을 `0xdeadbeef`로 설정하고 10초가 지나면 `corres` 에 `input`의 값이 대입된다  
후에 메뉴 3을 사용하면 조건을 만족해 플래그를 출력하게 된다

<details markdown="1">
<summary>스레드 스택</summary>

스레드는 독립적인 스택을 사용하기 때문에 스레드를 생성하기 전에 메뉴 1로 `input` 값을 설정해도 새로운 스레드에서는 `input` 값이 `NULL`이다

때문에 새로운 스레드를 생성한 후에 메뉴 1로 `input` 값을 설정해준 것이다  
</details>
<br>

---

```python
from pwn import *

port = 00000
p = remote('host1.dreamhack.games', port)

p.sendlineafter(b'Input: ', b'2')
p.sendlineafter(b'Input: ', b'1')
p.sendlineafter(b'Input: ', b'3735928559')

time.sleep(10)

p.sendlineafter(b'Input: ', b'3')
print(p.recvline().decode())
```

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FpbX29%2FbtsL1igRi5B%2FtkpiiKZz7iQF8ntSzhUjs1%2Fimg.png)  
<br>

---

### TOCTOU (Time-Of-Check to Tiime-Of-Use)

레이스 컨디션을 이용한 보안 취약점 중 하나이다  
앞서 봤던 드림핵 문제에서도 확인할 수 있다  
<br>

---

```c
if (access("file.txt", W_OK) == 0) { // 파일 쓰기 가능 여부 확인
	fd = open("file.txt", O_WRONLY); // 파일 열기
	write(fd, "data", 4); // 데이터 쓰기
}
```

`file.txt`에 write permission이 있으면 파일을 열어 데이터를 쓰는 코드이다  
만약 `access` 함수가 실행되고 `open` 함수가 실행되기 전에 `file.txt` 파일의 이름을 `/etc/passwd` 등 심볼릭 링크로 변경할 수 있다

이렇게 되면 `open` 함수는 `/etc/passwd`를 열게 되면서 시스템 파일을 덮어쓸 수 있게 된다  
이처럼 검사(TOC)와 사용(TOU) 사이에 상태가 변하는 문제가 레이스 컨디션을 유발하게 된다

---

### 레이스 컨디션 방지

#### 동기화(Synchronization) 기법

-   뮤텍스 **(Mutex)**를 사용해 한 번에 하나의 프로세스 또는 스레드만 공유 리소스에 접근하도록 제한할 수 있다
-   세마포어 **(Semaphore)**로 공유 리소스에 접근 가능한 최대 프로세스 또는 스레드의 수를 제한할 수 있다
-   **Atomic Operations**를 이용해 중간에 인터셉트 없이 한번에 수행되는 연산을 사용할 수 있다

#### 임시 파일 사용 시 보안 강화

-   `O_EXCL`옵션을 사용해 이미 존재하는 파일을 덮어쓰지 않도록 한다
-   /tmp 디렉터리 내에서 파일을 생성할 때 `mkstemp()` 함수를 사용한다

#### 권한 변경 시 안전한 방법 사용

-   `chmod()`를 사용하기 전 파일의 소유자가 변경되었는지 확인하는 로직을 추가할 수 있다
-   `open()`과 `chmod()`를 연속적으로 실행하지 않고 `fchmod()`를 사용해 파일 디스크립터를 직접 수행할 수 있다