---
title: "[2024 May Space War Web] Writeup"
description: 2024년 5월 Web 테마 hspace Space War Writeup
date: 2024-05-12 02:25:00 +0900
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

![Image](https://blog.kakaocdn.net/dn/bXHegf/btsHm1wqqtn/QKQL5CI9lru6Amor6pvj8k/img.png)

HSpace 카카오톡 공지방에 공지 뜨길래 심심해서 참가해봤다.  
조빱이라 꽁으로 주는 한 문제랑 3문제 풀었다.
* Scroll_Master
* jelly shop
* Exec Anything

<br>

---

## Scroll\_Master


Inspired by Click Master, I created Scroll Master. 

Please continue scrolling the mouse.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cVi6gk/btsHmagsDtW/XaHihzomgrbOuHMrgpPld1/img.png)

문제 설명만 봐도 알 수 있듯이 그냥 스크롤 엄청 하면 풀리는 것 같다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/bbU6He/btsHmcefaXe/gopep9zSWb8UTIIlehhwKK/img.png)

개발자 도구로 소스 코드 보면 스크립트 볼 수 있는데 난독화가 되어있다..  
그냥 스크롤하면 될 거라 믿고 가보기로 한다.  

클릭하는 문제만 풀어봐서 개발자 콘솔에서 js로 매크로 짜서 하려고 했는데 내 검색 실력으로는 아무리 찾아봐도 스크롤 이벤트를 발생시키는 간단한 js코드를 찾기 쉽지 않았다..  
<br>

---

```python
# https://gitlab.com/RincewindLangner/mouse-wheel-spinner/
    
    import time
    from pynput import keyboard
    from pynput.keyboard import Key
    from pynput.mouse import Controller
    
    mouse = Controller()
    
    def key_check(key):
        global continueLooping
        try:
            if key.char == 'y':
                continueLooping = True
            if key.char != 'y' and key != keyboard.Key.esc:
                mouse.scroll(dx=0, dy=0)
        except AttributeError:
            print('Check')
    
    def on_release(key):
        global continueLooping
    
        if key == Key.esc:
            continueLooping = False
            mouse.scroll(dx=0, dy=0)
    
    def scroll_wheel():
        mouse.scroll(dx=0, dy=-10000000000)
    continueLooping = False
    
    listener = keyboard.Listener(
        on_press=key_check,
        on_release=on_release)
    listener.start()
    
    while True:
        time.sleep(1)
        while continueLooping:
            scroll_wheel()
```

그래서 어쩔 수 없이 마인크래프트에 쓰이는 스크롤 매크로 코드를 어찌저찌 구해서 수정해서 썼다.  
코드 실행하고 y 누르면 아래로 스크롤을 하기 시작하는데 기다리다 보면 퍼센트 게이지가 채워진다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cHQ7cN/btsHofAkmCw/Xcra318NiIY0fCtHyJppKk/img.png)

퍼센트 게이지를 다 채우고 나면 이렇게 플래그를 얻을 수 있다.  
<br>

---
## jelly shop

젤리샵에 오신걸 환영합니다.  

jelly_shop-for_user.zip  
<br>

---

![Image](https://blog.kakaocdn.net/dn/SljbW/btsHl1qD3aA/TE4qX6nZsz3kfUtZrjpStK/img.png)

장바구니에 여러 젤리들을 담고 결제할 수 있다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cnfy6K/btsHmTL6E2u/8I7GAkq8QaZUrQqjOQYPik/img.png)

결제하기 버튼을 누르면 주문 번호와 결제 금액이 나온다.  
<br>

---

```python
@app.route('/order', methods=['POST'])
    def order():
      json = request.get_json()
      result = eval(json['total'])
      if not result: return '주문과정 중 에러가 발생했습니다.'
      elif isinstance(result,int): return '주문이 완료되었습니다.'
      return result
```

코드를 한번 살펴보자

eval is evil 이라는 말이 있는데도 불구하고 겁댕아리 없이 `eval` 함수를 쓰고 있는 모습이다.  
`total` 값이 결제 금액에 출력되는데 URL에서 수정해서 리퀘스트 보내면 될 것 같다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/bZ3DH0/btsHmZyx3qu/k5LraTsjpwkud7jYLNtl8K/img.png)

야무지게 플래그 파일 있는 위치 열어서 읽으라 하면 출력해준다.  
`?total=open("./app/plag/flag.txt","r").read()`  
파이썬에서 open 함수에서 상대 경로 쓸때는 매번 헷갈린다;;

이번에도 역시 경로 때문에 시간을 상당히 많이 썼다..  
<br>

---
## Exec Anything

Execute anything you want!  

Exec_Anything-for_user.zip  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cn3KTn/btsHn6XOrL5/SYDUerKSowvKlB9zOiKN1K/img.png)

함수 이름과 인자를 입력할 수 있는 폼이 있다.  
<br>

---



```php
<?php
    $disallowed_functions = ['system', 'eval', 'exec', 'shell_exec', 'passthru', 'popen', 'proc_open', 
                            'fopen', 'file_get_contents', 'readfile', 'include', 'require', 'include_once', 
                            'require_once', 'parse_ini_file', 'show_source', 'highlight_file', 'var_dump', 
                            'print_r', 'var_export', 'debug_zval_dump', 'debug_print_backtrace', 
                            'get_defined_vars', 'get_defined_functions', 'get_defined_constants', 
                            'get_included_files', 'get_required_files', 'get_declared_classes', 
                            'get_declared_interfaces', 'get_declared_traits'];
                            
    if (isset($_GET['function_name'])) {
        $func = $_GET['function_name'];
        $args = $_GET['args'] ?? '';
    
        $args = explode(',', $args);
        array_walk($args, function(&$item) { $item = trim($item); });
        
        $output = call_user_func_safely($func, $args);
        echo '<pre>' . print_r($output, true) . '</pre>';
    } else {
        echo '<form method="get">
                Function Name: <input type="text" name="function_name" placeholder="Enter function name">
                <br>
                Arguments: <input type="text" name="args" placeholder="Comma-separated arguments">
                <br>
                <input type="submit" value="Execute">
              </form>';
    }
    ?>
```

사용할 수 없는 함수들이 배열로 들어가 있고, Execute하면 execute한 결과가 출력된다고 한다.  
인자도 여러 개를 받을 경우 쉼표로 구분되어 함수에 인자로 입력된다.  
<br>

---

```conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
    
        SetEnv flag "hspace{?}"
    
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
```

Docker 관련 파일인데 `SetEnv`로 플래그가 환경 변수에 저장되어 있다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/wwiKo/btsHmcee9LW/d40rf8DCtjVC9XdUQzynw1/img.png)

php 명령어를 잘 몰라서 걱정했지만 차근차근 찾아보기로 했다.  

일단 환경 변수로 플래그가 저장되어 있기 때문에 환경 변수 함수부터 찾아봤다.  
`getenv`라는 함수를 원트에 찾았는데 `http_host`를 테스트로 흘려보내니까 정상적으로 잘 작동되는 것 같다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cvZzHB/btsHl3242n2/QnyDxkzZrdWVJKXzFkvuk1/img.png)

바로 `getenv`함수에다가 인자로 flag를 주니까 플래그가 출력됐다.  
<br>

---

![Image](https://blog.kakaocdn.net/dn/d53daB/btsHncRQBwR/ubwIHy77mkN0tFfkVZ9pY0/img.png)

참여자가 많이 없어서 탑텐을 해버렸다 개꿀ㅋㅋ  
<br>

---


![Image](https://blog.kakaocdn.net/dn/uVRXl/btsHmXtSXhZ/hW1UoU0kWGWfMkxysp5hYK/img.png)

사실 참여한 거 좀 후회된다.  
안 그래도 온라인 강의도 쌓였고 과제도 밀리고 동아리 과제도 해야 되서 시간도 없는데 뻘짓한 것 같다.  

어떻게든 할 거 다 하고 짬 내서 수능 공부도 해야 하는데 이럴 거면 6모는 왜 신청했지..ㅋㅋ
차라리 3등 안에 들었으면 상품권이라도 받으니 괜찮은데 순위권에도 못 들고 이게 뭐야..  

내 아까운 시간 아깝지라도 않으려고 이렇게 WriteUp이라도 써서 작은 소정의 상품이라도 받아보려고 써봤다..

