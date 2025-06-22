---
title: bootlean glibc 2.35 malloc.c 분석
description: bootlean glibc 2.35 malloc.c _int_malloc, _int_free 함수 분석하기
date: 2025-06-22 03:07:00 +0900
categories: [Security, System Hacking]
tags: [security, system, analysis]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false

---

`_int_malloc`, `_int_free` 함수 코드를 분석하는 것이 목표다  
함수와 매크로를 따라가면서 정리한다  

본인은 운영체제, 컴퓨터 구조 등 CS 지식이 빈약하기 때문에 최대한 상세하게 작성해볼 생각이다

<https://elixir.bootlin.com/glibc/glibc-2.35/source/malloc/malloc.c>

# 1. _int_malloc()

```c
// mallo/malloc.c
static void*  _int_malloc(mstate, size_t); // 1108 line
```

인자로 `mstate`, `size_t`를 받는다

---

## 1-1. 자료형 mstate

```c
// include/malloc.h
#ifndef _MALLOC_H

#include <malloc/malloc.h>

# ifndef _ISOMAC
#  include <rtld-malloc.h>

struct malloc_state;
typedef struct malloc_state *mstate;

# endif /* !_ISOMAC */

#endif
```

`include/malloc.h` 헤더 파일에 `mstate` 구조체 자료형이 typedef로 정의되어 있다
`malloc_state` 구조체를 가리키는 포인터 자료형이다

```c
// malloc/malloc.h
#ifndef _MALLOC_H
#define _MALLOC_H 1
```

`_MALLOC_H`는 `malloc/malloc.h` 헤더 파일에서 정의된다

`_MALLOC_H`가 정의되어 있지 않을 경우 1로 정의되기 때문에 `include/malloc.h` 헤더 파일에서 `malloc/malloc.h` 헤더 파일을 참조할 수 있게 된다

```c
// include/libc-symbols.h
#if IS_IN (testsuite) || defined IS_IN_build || defined __cplusplus
# define _ISOMAC 1
#endif
```

`_ISOMAC`은 `include/libc-symbols.h` 헤더 파일에서 1로 정의된다

glibc 자체 테스트 코드 컴파일 또는 빌드 도중 생성되는 보조 도구 컴파일 또는 C++ 컴파일 시 자동으로 1로 정의되는 것을 알 수 있다

### 1-1-1. malloc_state 구조체

```c
// malloc/malloc.c
struct malloc_state
{
  /* Serialize access. 접근을 직렬화한다  */
  __libc_lock_define (, mutex);

  /* Flags (formerly in max_fast). 플래그 (이전에는 max_fast)  */
  int flags;

  /* Set if the fastbin chunks contain recently inserted free blocks.  */
  /* fastbin 청크가 최근에 삽입된 free 청크들을 포함할 때 설정됨 */
  /* Note this is a bool but not all targets support atomics on booleans.  */
  /* bool 타입이지만 모든 대상이 boolean에 atomics를 지원하지는 않음 */
  int have_fastchunks;

  /* Fastbins */
  mfastbinptr fastbinsY[NFASTBINS];

  /* Base of the topmost chunk -- not otherwise kept in a bin */
  /* 가장 꼭대기 청크의 베이스 -- bin에서 유지됨 */
  mchunkptr top;

  /* The remainder from the most recent split of a small request */
  /* 가장 최근에 분할된 작은 요청의 나머지 */
  mchunkptr last_remainder;

  /* Normal bins packed as described above */
  /* 위에서 설명했듯이 패킹된 일반 bins */
  mchunkptr bins[NBINS * 2 - 2];

  /* Bitmap of bins */
  unsigned int binmap[BINMAPSIZE];

  /* Linked list 연결리스트 */
  struct malloc_state *next;

  /* Linked list for free arenas.  Access to this field is serialized
     by free_list_lock in arena.c.  */
  /* free 아레나 연결리스트.
     이 필드에 대한 접근은 arena.c의 free_list_lock에 의해 직렬화됨 */
  struct malloc_state *next_free;

  /* Number of threads attached to this arena.  0 if the arena is on
     the free list.  Access to this field is serialized by
     free_list_lock in arena.c.  */
  /* 이 아레나에 연결된 스레드의 수
     아레나가 free 리스트에 있으면 0
     이 필드에 대한 접근은 arena.c의 free_list_lock에 의해 직렬화됨 */
  INTERNAL_SIZE_T attached_threads;

  /* Memory allocated from the system in this arena.  */
  /* 이 아레나에서 시스템으로부터 할당 받은 메모리 */
  INTERNAL_SIZE_T system_mem;
  INTERNAL_SIZE_T max_system_mem;
};
```

위와 같은 구조체 구조를 가진다
연결리스트 형식으로 구현되는 것을 알 수 있다

주로 스레드 아레나와 관련된 정보를 저장한다
**멀티스레드 환경에서 여러 스레드가 독립적으로 메모리 할당을 효율적이고 안전하게 수행할 수 있도록 한다**

해당 아레나에 속한 힙의 정보(크기, 시작 주소, 이전/다음 힙 정보), 할당 및 해제 추적, 동기화 관련 정보를 포함한다

`malloc()` 함수는 요청된 메모리 크기대로 메모리 블록을 할당할 때 `malloc_state` 구조체를 참조하여 메모리 블록을 찾고 필요하면 새로운 힙을 할당받거나 확장한다
`free()` 함수는 `malloc_state` 구조체를 업데이트하며 할당된 메모리 블록을 해제한다

- __libc_lock_define (, mutex)
    
    ```c
    /* Serialize access. 접근을 직렬화한다  */
    __libc_lock_define (, mutex);
    ```
    
    ```c
    // sysdeps/mach/libc-lock.h
    typedef unsigned int __libc_lock_t;
    
    ...
    
    /* Define a lock variable NAME with storage class CLASS.  The lock must be
       initialized with __libc_lock_init before it can be used (or define it
       with __libc_lock_define_initialized, below).  Use `extern' for CLASS to
       declare a lock defined in another module.  In public structure
       definitions you must use a pointer to the lock structure (i.e., NAME
       begins with a `*'), because its storage size will not be known outside
       of libc.  */
    #define __libc_lock_define(CLASS,NAME) \
      CLASS __libc_lock_t NAME;
    ```
    
    `mutex` 변수를 `__libc_lock_define` 매크로에 전달한다
    
    사실상 `__libc_lock_t` 자료형으로 `mutex` 이름의 변수를 선언하는 것과 같다
    
    ```c
    __libc_lock_t mutex;
    ```
    
    사실상 위와 같은 의미이다
    `malloc_state` 내부에 플랫폼 독립적 뮤텍스 변수 `mutex`를 선언하라는 매크로 호출이다
    
    아레나에 대한 접근을 동기화하는 뮤텍스이다
    
    `sysdeps/mach/libc-lock.h`, `sysdeps/generic/libc-lock.h`, `sysdeps/nptl/libc-P.h` 처럼 플랫폼별 버전이 존재하는데 `__libc_lock_t`로 묶어서 하나의 매크로를 사용할 수 있도록 한다
    덕분에 glibc는 다양한 플랫폼에서 동일한 소스를 유지하며 빌드 설정에 맞춰 최적의 안전한 락을 자동으로 선택할 수 있다
    해당 소스에서는 `__libc_lock_t`를 부호 없는 정수형으로 사용한다
    
    glibc 내부의 락(뮤텍스) 변수를 선언하기 위한 매크로이다
    이 락을 통해 `malloc_state` 하나에 여러 스레드가 동시에 들어오지 못하도록 접근을 직렬화한다.
    
    | 값 | 매크로 | 의미 |
    | --- | --- | --- |
    | 0x0 | LLL_LOCK_INITIALIZER | 열려 있음 |
    | 0x1 | LLL_LOCK_INITIALIZER_LOCKED | 잠금, 대기자 없음 |
    | 0x2 | LLL_LOCK_INITIALIZER_WAITERS | 잠금, 대기자 존재 |
    
    `LLL_LOCK_INITIALIZER`, `LLL_LOCK_INITIALIZER_LOCKED`는 각각 `sysdeps/nptl/lowlevellock.h` 또는 `mach/lowlevellock.h`에 0, 1 정수 상수로 정의되어 있다
    `LLL_LOCK_INITAILIZER_WAITERS`는 어디에 정의되어 있는지 모르겠다..
    
- flags
    
    ```c
    /* Flags (formerly in max_fast). 플래그 (이전에는 max_fast)  */
    int flags;
    ```
    
    아레나의 상태를 나타내는 플래그이다.
    
    | 비트 | 매크로 | 용도 |
    | --- | --- | --- |
    | 0  | FASTCHUNKS_BIT | 사용하지 않음 |
    | 1 | NONCONTIGUOS_BIT | 단일 연속 영역이 아닌지 |
    | 2~31 | (Reserved) | 정의되지 않음 |
    
    32비트 크기의 int 자료형을 잘라서 비트별로 의미를 가진다
    
    - `FASTCHUNKS_BIT`
        
        0번째 비트의 경우 glibc 2.26 버전 이전까지는 최근에 free된 청크가 있으면 플래그가 켜졌지만 `have_fastchunks` 독립 필드로 분리되었다
        glibc 2.26 이전까지는 `flags`의 하위 8비트에 `max_fast` 값이 들어가고 상위 비트에는 `FASTCHUNKS_BIT`만 보관하였다
        glibc 2.26부터 `max_fast`가 전역 변수화가 되면서 `flags`에서 제거되었고 `FASTCHUNKS_BIT`는 정의만 남고 실제로 사용되지는 않는다
        
        glibc 2.34-2.35에서 `flags`에서 `NONCONTIGUOUS_BIT`만 실제로 사용된다
        
    
    새 아레나가 `mmap`으로 생성되거나 ASLR 등으로 sbrk-힙 단절이 감지되는 경우에 켜진다
    한 번 켜지면 꺼지지 않는다
    
    ```c
    #define NONCONTIGUOUS_BIT     (2U)
    
    #define contiguous(M)          (((M)->flags & NONCONTIGUOUS_BIT) == 0)
    #define noncontiguous(M)       (((M)->flags & NONCONTIGUOUS_BIT) != 0)
    #define set_noncontiguous(M)   ((M)->flags |= NONCONTIGUOUS_BIT)
    #define set_contiguous(M)      ((M)->flags &= ~NONCONTIGUOUS_BIT)
    ```
    
    `NONCONTIGUOUS_BIT`는 초기 0값에 `set_noncontiguous` 에 의해  `NONCONTIGUOUS_BIT` 와의 OR 연산을 통해 설정되는데 `NONCONTIGUOUS_BIT`는 2U 값을 갖는다
    
- have_fastchunks
    
    ```c
    /* Set if the fastbin chunks contain recently inserted free blocks.  */
    /* fastbin 청크가 최근에 삽입된 free 청크들을 포함할 때 설정됨 */
    /* Note this is a bool but not all targets support atomics on booleans.  */
    /* bool 타입이지만 모든 대상이 boolean에 atomics를 지원하지는 않음 */
    int have_fastchunks;
    ```
    
    fastbin 안에 최근에 free된 블록이 있는지를 나타내는 플래그이다
    0과 1로 나타낸다
    
    ```c
    // malloc/malloc.c
    static void
    malloc_init_state (mstate av)
    {
      int i;
      mbinptr bin;
    
      /* Establish circular links for normal bins */
      for (i = 1; i < NBINS; ++i)
        {
          bin = bin_at (av, i);
          bin->fd = bin->bk = bin;
        }
    
    #if MORECORE_CONTIGUOUS
      if (av != &main_arena)
    #endif
      set_noncontiguous (av);
      if (av == &main_arena)
        set_max_fast (DEFAULT_MXFAST);
      atomic_store_relaxed (&av->have_fastchunks, false);
    
      av->top = initial_top (av);
    }
    ```
    
    `malloc_init_state()` 함수가 호출되면 인자로 받은 `mstate`의 `have_fastchunks`를 0(False)로 설정한다
    
- top
    
    힙의 마지막 할당 위치를 가리키는 포인터
    
- last_remainder
    
    마지막으로 사용된 메모리 조각의 정보 저장