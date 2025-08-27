---
title: "델파이(Delphi) 리버싱 / (SuNiNaTaS 11번)"
description: "Suninatas 11번 델파이 리버싱 문제 풀이 및 델파이 분석 방법"
date: 2025-08-27 21:45:00 +0900
categories: [Security, Reverse Engineering]
tags: [delphi, reversing]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

써니나타스 올솔 트라이하면서 라이트업 통으로 써보고 있는데 거기에 쓰면 너무 길 것 같아서 따로 뺀다  

지금까지 깨작깨작 했던 리버싱과는 다르게 여러 도구를 활용해보면서 사용법을 익혀볼 수 있었다  
당연한 말이지만 그저 시작부터 IDA 돌리고 지피티 딸깍딸깍하는 건 절대 안 된다는 것을 알게 되었다  

기드라도 한참 전에 깔아놓고 안 쓰고 있었는데 이번에 써보게 됐다  
TMI인데 예전에 CTF 디코에서 어떤 외국인은 지하이드라라고 하더라  
어떤 발음이 맞는지는 모르겠당  
<br>

---

리버싱을 하기 전에 바이너리 파일이 하나 주어지면 PEiD 같은 걸로 한번 보고 그에 맞는 도구를 찾아 쓰는 게 제일 빠른 것 같다  

물론 그냥 IDA 돌려서 할 수도 있고 도구 찾느라 시간만 보낼 수도 있긴 하다  
하지만 한번 해두면 나중에 같은 유형의 바이너리를 만났을 때 그때 유용하게 썼던 도구를 사용해서 훨씬 빠르게 풀 수 있을 것이다  
<br>

---

뭔가 새로운 경험을 할 때마다 이제 공부 방향이 잡혀가는구나 싶다가도 나중 되면 아니었구나를 깨닫게 되는데 아마 이번에도 그럴 것이다..  
<br>
<br>

---

## Suninatas 11

별 설명 없이 `Project1.exe` 바이너리 파일 하나 주어진다  
<br>

---

![Image](/assets/img/250825_0/wsl_file.png)

[file](https://linux.die.net/man/1/file) 명령어를 사용해보면 어떤 파일인지 확인할 수 있다  

윈도우에서 사용되는 32비트 PE GUI 파일이라고 한다  
<br>

---

![Image](/assets/img/250825_0/executed.png)

직접 실행해보면 위와 같다  

"Find RegisterKEY" 문자열과 함께 입력칸이 주어진다  
아무거나 누르고 Register 버튼을 누르면 그냥 아무 일도 일어나지 않는다  

어떤 일이 일어나도록 하는 입력값을 찾아야 할 것 같다  
<br>
<br>

---

### Delphi (델파이)

VC++, VC, Delphi 등으로 소스 코드를 작성하면 컴파일 시 컴파일러가 Stub Code를 추가하여 디스어셈블을 하면 복잡해 보인다  

델파이의 함수 호출 규약에서는 함수의 인자를 전달할 때 `EAX`, `EDX`, `ECX` 순으로 전달되고 그 이후로는 스택을 통해 전달된다  
<br>
<br>

---

### IDA를 사용한 분석

![Image](/assets/img/250825_0/ida_strings.png)

사실 IDA에서 Strings만 뽑아봐도 AuthKey를 눈치챌 수 있지만 모른다는 가정 하에 풀어본다  

"Congratulation!"라는 문자열이 있는 것으로 보아 적절한 값을 입력하면 Authkey를 알려주는 구조인 것 같다  

그렇다면 "Congratulation!"을 출력하는 문자열을 호출하는 부분의 함수를 찾아보면 동작을 분석해볼 수 있을 것이다  
<br>

---

![Image](/assets/img/250825_0/ida_congratulation_ref.png)

더블 클릭한 후에 `aCongratulation`을 우클릭한다  
해당 문자열을 호출하는 부분을 찾기 위해 `List cross references to...`을 선택한다  
<br>

---

![Image](/assets/img/250825_0/ida_congratulation_ref_function.png)

그러면 해당 문자열을 호출하는 부분들이 리스트로 나오는데 여기서는 다행히 하나 밖에 없다  
OK를 눌러 이동할 수 있다  
<br>

---

```c++
int __fastcall TForm1_Button1Click(int a1)
{
    int v2; // ecx
    char v3; // zf
    const CHAR *v4; // eax
    unsigned int v6[2]; // [esp-10h] [ebp-18h] BYREF
    int *v7; // [esp-8h] [ebp-10h]
    int v8; // [esp+0h] [ebp-8h] BYREF
    int v9; // [esp+4h] [ebp-4h] BYREF
    int savedregs; // [esp+8h] [ebp+0h] BYREF

    v9 = 0;
    v8 = 0;
    v7 = &savedregs;
    v6[1] = (unsigned int)&loc_4503D1;
    v6[0] = (unsigned int)NtCurrentTeb()->NtTib.ExceptionList;
    __writefsdword(0, (unsigned int)v6);
    System::__linkproc__ LStrAsg(a1 + 784, &str_2V[1]);
    System::__linkproc__ LStrAsg(a1 + 788, &str_XS[1]);
    System::__linkproc__ LStrAsg(a1 + 792, &str_B6[1]);
    System::__linkproc__ LStrAsg(a1 + 796, &str_H1[1]);
    System::__linkproc__ LStrAsg(a1 + 800, &str_0F[1]);
    System::__linkproc__ LStrCatN(
        a1 + 816,
        5,
        v2,
        *(_DWORD *)(a1 + 792),
        *(_DWORD *)(a1 + 796),
        *(_DWORD *)(a1 + 788),
        *(_DWORD *)(a1 + 800));
    Controls::TControl::GetText(*(Controls::TControl **)(a1 + 756));
    System::__linkproc__ LStrCmp(v9, *(_DWORD *)(a1 + 816));
    if ( v3 )
    {
        System::__linkproc__ LStrCat3((int)&v8, *(void **)(a1 + 812), *(void **)(a1 + 804));
        v4 = (const CHAR *)System::__linkproc__ LStrToPChar(v8);
        MessageBoxA_0(0, v4, "Congratulation!", 0);
    }
    Controls::TControl::SetText(*(Controls::TControl **)(a1 + 756), 0);
    System::__linkproc__ LStrAsg(a1 + 812, &str_Authkey___[1]);
    __writefsdword(0, v6[0]);
    v7 = (int *)&loc_4503D8;
    System::__linkproc__ LStrClr(&v8);
    return System::__linkproc__ LStrClr(&v9);
}
```

버튼 클릭 함수(`TForm1_Button1Click()`)가 나온다  
버튼이 하나 밖에 없기에 Register 버튼을 눌렀을 때의 동작과 관련된 것일 것이다  
<br>

---

```c++
System::__linkproc__ LStrCmp(v9, *(_DWORD *)(a1 + 816));
if ( v3 )
{
System::__linkproc__ LStrCat3((int)&v8, *(void **)(a1 + 812), *(void **)(a1 + 804));
v4 = (const CHAR *)System::__linkproc__ LStrToPChar(v8);
MessageBoxA_0(0, v4, "Congratulation!", 0);
}
```

가끔 이렇게 `v3`처럼 IDA에서 못 잡는 경우가 있는데 조건문 조건으로 들어가 있으면 이전 비교문에서 반환되는 값인 경우가 많다  
해당 코드도 `LStrCmp()` 함수 이후 조건문 조건으로 등장하였으니 `LStrCmp()` 함수에서 `a1 + 816`과 `v9`을 비교한 결과가 `v3`로 사용될 것이다  

그러면 `v9`은 무엇일까  
<br>

---

```c++
return System::__linkproc__ LStrClr(&v9);
```

마지막에 `v9`을 `LStrClr()`로 문자열을 지워버리는데 실제로 Register 버튼을 누르면 입력 칸에 입력했던 문자열이 지워진다  

100% 확실하다고 보장할 수는 없지만 `v9`은 사실상 입력 칸에 입력한 문자열이다  
따라서, `LStrCmp()` 함수는 사용자가 입력한 `v9` 문자열과 `a1 + 816`의 값을 비교한다  
<br>

---

```c++
System::__linkproc__ LStrAsg(a1 + 784, &str_2V[1]);
System::__linkproc__ LStrAsg(a1 + 788, &str_XS[1]);
System::__linkproc__ LStrAsg(a1 + 792, &str_B6[1]);
System::__linkproc__ LStrAsg(a1 + 796, &str_H1[1]);
System::__linkproc__ LStrAsg(a1 + 800, &str_0F[1]);
System::__linkproc__ LStrCatN(
a1 + 816,
5,
v2,
*(_DWORD *)(a1 + 792),
*(_DWORD *)(a1 + 796),
*(_DWORD *)(a1 + 788),
*(_DWORD *)(a1 + 800));
Controls::TControl::GetText(*(Controls::TControl **)(a1 + 756));
System::__linkproc__ LStrCmp(v9, *(_DWORD *)(a1 + 816));
```

`LStrCatN()` 함수를 사용한다  
C언어의 `strcat()`과 형태도 유사하고 비슷한 기능을 수행하지 않을까 싶다  

[여기](https://github.com/huettenhain/dhrake?tab=readme-ov-file#reparing-lstrcatn)를 참고하면 첫 번째 인자는 결과값이 들어갈 곳, 두 번째 인자는 붙일 개수, 세 번째 인자부터는 붙일 조각들이 들어간다  
<br>

---

![Image](/assets/img/250825_0/ida_fragments.png)

들어갈 문자 조각들은 `.code` 영역에 저장되어 있다  
순서를 맞춰서 붙여주면 입력해야 할 문자열은 "2VB6H1XS0F"이다  
<br>

---

![Image](/assets/img/250825_0/ida_congratulation.png)

입력하고 Register를 눌러보면 Authkey가 나오는 것을 확인할 수 있다  

그러면 이제 Authkey를 바로 뽑아보자  
<br>

---

![Image](/assets/img/250825_0/ida_formcreate.png)

Authkey가 만들어지는 문자열 조각들이다  
`TForm1_FormCreate()` 함수에서 사용된다  
<br>

---

```c++
int __fastcall TForm1_FormCreate(volatile __int32 *a1)
{
    int v2; // ecx

    System::__linkproc__ LStrAsg(a1 + 192, (__int32)&str_2abbe4b6[1]);
    System::__linkproc__ LStrAsg(a1 + 193, (__int32)&str_44536ca0[1]);
    System::__linkproc__ LStrAsg(a1 + 194, (__int32)&str_81aae922[1]);
    System::__linkproc__ LStrAsg(a1 + 195, (__int32)&str_e32fa0de[1]);
    return System::__linkproc__ LStrCatN(
        a1 + 201,
        4,
        v2,
        *((_DWORD *)a1 + 192),
        *((_DWORD *)a1 + 194),
        *((_DWORD *)a1 + 193),
        *((_DWORD *)a1 + 195));
}
```

이전과 마찬가지로 `LStrCatN()` 함수를 사용하여 Authkey를 만드는 것을 확인할 수 있다  
<br>

---

사실 이게 지금까지 내가 리버싱 문제를 풀어왔던 방식이다  
풀이 논리는 이런 식이고 패치를 통한 풀이는 후술해보겠다  

IDA로 쉬운 문제만 풀어왔지 어려운 문제는 풀지 못한 적이 더 많다..  
때문에 이번엔 다른 도구들을 사용해본 것도 있다  
<br>
<br>

---

### IDR을 사용한 분석 

[IDR](https://github.com/crypto2011/IDR)(Interactive Deplhi Reconstructor)은 델파이 바이너리를 디컴파일하는 프로그램이다  
Delphi Knowledge Base라는 바이너리 압축 파일이 포함되어 있는데 분석할 버전에 해당하는 Delphi Knowledge Base 파일을 찾아 `/bin/`{: .filepath} 경로에 포함시켜야 한다  
(IDR이 `/bin/`{: .filepath}에 있는 경우)
<br>

---

![Image](/assets/img/250825_0/peid.png)

PEiD를 사용하여 확인해보면 Borland Delphi 6.0으로 패킹되어 있으니 `kb6.bin`{: .filepath} 파일을 Delphi Knoledge Base 파일로 사용하면 된다  

굳이 PEiD를 사용하지 않아도 일단 File > Load File > Autodetect Version 선택하면 어떤 Delphi Knowledge Base 파일이 필요한지 알 수 있다  
<br>

---

![Image](/assets/img/250825_0/idr.png)

어셈블리어로 확인할 수도 있고 SourceCode에서 IDA처럼 코드 형태로도 확인할 수 있다  

라벨링도 없고 여기서 분석하는 건 쉽지 않다..  
플러그인을 사용해서 기능을 추가할 수도 있겠지만 더 편하게 분석하기 위해 Ghidra로 분석을 이어가보자  

Ghidra로 분석하기 전에 해야 할 것이 있다  
<br>

---

상단 내비게이션 바의 Tools > IDC Generator에서 `.idc` 파일을 생성해야 한다  
이 파일에는 IDR에서 분석된 델파이 바이너리의 메타 데이터가 저장되어 있다  
<br>
<br>

---

### Ghidra를 사용한 분석

예전부터 Ghidra를 써보고 싶었지만 IDA만 쓰다가 Ghidra 쓰려니까 어색해서 손이 안 갔다  

사실 이번에도 Ghidra로 분석해보자가 아니라 MCP 서버 붙여서 바이브 리버싱을 해보자 근데 IDA Pro가 아니네 Ghidra로 해봐야겠다로 출발한 것이다..  
<br>

---

```c++
void entry(void)

{
  FUN_00406578(&DAT_00450560);
  FUN_0044eb78();
  FUN_0044eb90(*(int *)PTR_DAT_00451e20,(int)&PTR_LAB_004500b0,(undefined4 *)PTR_DAT_00451ef4);
  FUN_0044ec10(*(int *)PTR_DAT_00451e20);
                    /* WARNING: Subroutine does not return */
  FUN_0040411c();
}
```

IDA에서와는 다르게 Ghidra는 델파이 바이너리의 함수 이름을 복구하지는 못한다..  
이는 [Dhrake](https://github.com/huettenhain/dhrake)라는 스크립트를 사용하여 해결할 수 있다  

Ghidra의 장점은 오픈 소스라서 이러한 스크립트나 플러그인을 자유롭게 사용할 수 있는 것인 것 같다  
<br>

---

![Image](/assets/img/250825_0/ghidra_script_manager.png)

상단 네비게이션 바에서 Window > Script Manager에서 스크립트를 추가하고 실행할 수 있다  

`DhrakeInit.java`{: .filepath} 스크립트를 실행한 후 [이전](https://blog.kogandhi.kr/posts/suninatas-delphi-reverse-engineering/#idr을-사용한-분석)에 생성했던 `.idc` 파일을 선택하여 실행한다  

`.idc`에 메타데이터가 들어있기 때문에 덮어씌울 수가 있다  
<br>

---

```c++
void EntryPoint(void)

{
  @InitExe(&DAT_00450560);
  TApplication.Initialize();
  TApplication.CreateForm
            (*(int *)Application,(int)&PTR_TWinControl.AssignTo_004500b0,(undefined4 *)gvar_00451EF4
            );
  TApplication.Run(*(int *)Application);
                    /* WARNING: Subroutine does not return */
  @Halt0();
}
```

실행이 완료되면 이렇게 함수 이름, 변수 등의 이름이 `.idc` 파일을 토대로 설정된 것을 확인할 수 있다  
<br>

---

```c++
void UndefinedFunction_0045028c(int param_1,undefined2 param_2)

{
    undefined4 uVar1;
    LPCSTR lpText;
    int unaff_EBX;
    undefined1 *unaff_EBP;
    int unaff_ESI;
    undefined4 *in_FS_OFFSET;
    bool in_CF;
    bool bVar2;
    char *pcVar3;
    UINT uType;
    undefined4 uStack_20;
    undefined1 *puStack_1c;
    undefined1 *puStack_18;

    out(*(undefined4 *)(unaff_ESI + 1),param_2);
    if (!in_CF) {
        *(uint *)(param_1 + 0x14004500) = *(uint *)(param_1 + 0x14004500) ^ (uint)(unaff_ESI + 5);
        pcVar3 = (char *)(param_1 * 2 + 5);
        *pcVar3 = *pcVar3 + (char)unaff_EBX;
        puStack_18 = &stack0xfffffff8;
        unaff_EBP = &stack0xfffffff8;
        out(*(undefined1 *)(unaff_ESI + 5),param_2);
        puStack_1c = &LAB_004503d1;
        uStack_20 = *in_FS_OFFSET;
        *in_FS_OFFSET = &uStack_20;
        @LStrAsg((int *)(param_1 + 0x310),(undefined4 *)&DAT_004503e8);
        @LStrAsg((int *)(param_1 + 0x314),(undefined4 *)&DAT_004503f4);
        @LStrAsg((int *)(param_1 + 0x318),(undefined4 *)&DAT_00450400);
        @LStrAsg((int *)(param_1 + 0x31c),(undefined4 *)&DAT_0045040c);
        unaff_EBX = param_1;
    }
    @LStrAsg((int *)(unaff_EBX + 800),(undefined4 *)&DAT_00450418);
    uVar1 = *(undefined4 *)(unaff_EBX + 800);
    @LStrCatN((char **)(unaff_EBX + 0x330),5);
    TControl.GetText(*(int *)(unaff_EBX + 0x2f4),(int *)(unaff_EBP + -4));
    bVar2 = @LStrCmp(*(char **)(unaff_EBP + -4),*(char **)(unaff_EBX + 0x330));
    if (bVar2) {
        uType = 0;
        pcVar3 = "Congratulation!";
        @LStrCat3((char **)(unaff_EBP + -8),*(char **)(unaff_EBX + 0x32c),*(char **)(unaff_EBX + 0x324))
        ;
        lpText = @LStrToPChar(*(undefined **)(unaff_EBP + -8));
        user32.MessageBoxA_0((HWND)0x0,lpText,pcVar3,uType);
        TControl.SetText(*(int *)(unaff_EBX + 0x2f4),(uint *)0x0);
    }
    else {
        TControl.SetText(*(int *)(unaff_EBX + 0x2f4),(uint *)0x0);
    }
    @LStrAsg((int *)(unaff_EBX + 0x32c),(undefined4 *)"Authkey : ");
    *in_FS_OFFSET = uVar1;
    @LStrClr((int *)(unaff_EBP + -8));
    @LStrClr((int *)(unaff_EBP + -4));
    return;
}
```

동일하게 "Congratulation!"이 나오는 함수를 찾아 Authkey를 찾아내면 된다  
<br>
<br>

---

### DeDe를 사용한 분석

개인적으로 가장 편한 방법이었다..  

델파이 전용 리버싱 툴인데 공식적인 다운로드 페이지는 없다  
<br>

---

![Image](/assets/img/250825_0/dede.png)

파일을 로드시키고 Procedures 탭을 확인해보면 `Button1Click`과 `FormCreate` 이벤트들이 있는 것을 확인할 수 있다  
<br>

---

![Image](/assets/img/250825_0/dede_assembly.png)

각 이벤트를 클릭하면 어셈블리어로 동작을 확인할 수 있다  
이걸로 바로 입력값과 Authkey를 얻을 수 있다  

근데 하는 김에 패치까지 해보자  
<br>
<br>

---

#### 패치

문제에서 주어진 바이너리는 사용자가 값을 입력하면 `LStrCmp` 함수로 입력값과 특정값을 비교한다  
일치하면 Authkey를 알려주는데 `LStrCmp`에서 일치하지 않아도 되도록 분기를 반대로 패치하면 틀린 값을 입력하면 Authkey가 나오도록 할 수 있다  
<br>

---

```asm
* Reference to: System.@LStrCmp;
|
00450355   E8AE42FBFF             call    00404608
0045035A   753A                   jnz     00450396
0045035C   6A00                   push    $00

* Possible String Reference to: 'Congratulation!'
|
0045035E   681C044500             push    $0045041C
00450363   8D45F8                 lea     eax, [ebp-$08]
```

`jnz`로 분기하는데 이걸 반대로 패치하면 되겠다  
<br>

---

![Image](/assets/img/250825_0/x32.png)

`jne`로 되어 있는데 이걸 그냥 `je`로 반대로 바꿔서 패치하면 된다  
<br>

---

![Image](/assets/img/250825_0/x32_patched.png)

우클릭 > 어셈블 또는 스페이스바(단축키)  

`jnz`를 `jz`로 바꿔준다  
<br>

---

![Image](/assets/img/250825_0/patched.png)

패치 후 실행해보면 틀린 값을 입력해도 Authkey가 나온다  
<br>

---

사실 패치를 하는 방법은 스터디 등에서 실습으로 여러 번 해봐서 알고 있었지만 문제 풀면서 패치해서 바로 푼 적은 없는 것 같다..  

앞으로도 여러 가지 방법으로 접근해가면서 문제를 풀어봐야겠다  

Ghidra에 MCP 서버 붙여서 풀어보기도 했는데 일단 성능 이슈로 풀지는 못했고 다른 글로 따로 써보겠다  