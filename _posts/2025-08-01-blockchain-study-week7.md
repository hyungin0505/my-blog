---
title: "[Ethernaut] Level 1, 2 Writeup"
description: [Week7 블록체인]
date: 2025-08-01 16:50:00 +0900
categories: [Study, BlockChain]
tags: [blockchain]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

## Level 1

### 코드 분석

<details markdown="1">

<summary>전체 코드</summary>
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
```
</details>

우리는 컨트랙트 소유자의 권한을 탈취하고 소유자의 돈을 0이더로 만들어야 한다  
<br>

---

```solidity
constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
}
```
`constructor()`는 컨트랙트가 블록체인 상에 배포될 때 호출된다  
즉, 컨트랙트가 배포되면 `owner`는 컨트랙트 생성자로 설정되고 `owner`의 `contributions` 값은 1000 이더로 설정된다  
<br>

---

```solidity
function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if (contributions[msg.sender] > contributions[owner]) {
        owner = msg.sender;
    }
}
```

`contribute()` 메소드를 사용하여 호출자의 `contributions` 값에 `value` 만큼 이더를 추가할 수 있다  

다만, 0.001 이더 이상의 `value`는 추가하지 못한다  

호출자의 `contributions` 값이 `owner`보다 많아지면 `owner` 권한 탈취가 가능하다  

하지만, 0.001보다 작은 값으로 1000을 뛰어넘기 위해서는 수많은 트랜잭션이 이루어져야 하기에 다른 방법을 찾아보는 것이 낫다..  
<br>

---

```solidity
receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
}
```

`receive()`는 이더를 받으면 호출된다  
이때 `value`가 0보다 크고 호출자의 `contributions`가 0보다 크다면 `owner`가 호출자로 변경된다  

`external`이기에 `contribute` 등 내부 컨트랙트로는 작동하지 않고 외부에서 해당 컨트랙트로 송금을 해야 한다  

조건을 맞추고 외부에서 해당 컨트랙트로 송금을 하면 `owner`를 탈취할 수 있을 것으로 보인다  
<br>

---

```solidity
function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
}
```

출금하는 메소드 `withdraw()`를 사용해서 돈을 0으로 만들어버리면 될 것 같다  

`onlyOwner()` 생성자가 있기 때문에 먼저 `owner`를 탈취하는 것이 우선이다  
<br>

---

### 풀이

1. `contribute()`를 사용해 0.001보다 작은 0.0001 만큼의 이더를 송금하여 `contributions`에 기록한다  
2. 외부에서 트랜잭션 요청을 통하여 `receive()`를 호출한다  
3. `withdraw()` 메소드로 돈을 0원으로 만든다

<br>

---

![Image](/assets/img/250801_0/1.png)

보낼 때 `value`를 `wei` 단위로 사용해야 한다  
이더 단위를 wei로 바꾸는 명령어는 `help()`에서 확인할 수 있다  

> Solidity에서 `ether` 등은 문법적인 편의를 위한 것일 뿐 컴파일 이후에는 모두 `uint 256 wei`로 처리된다  
> EVM은 부동소수점이 없기 때문에 소수점 사용이 불가능하다 
> 따라서 `wei`로 환산된 정수를 사용해야 한다  
{: .prompt-info}

<br>

---

![Image](/assets/img/250801_0/2.png)

`owner` 따고 `withdraw()`로 돈까지 모두 빼고 Submit instance 누르면 통과된다  
<br>

---

## Level 2

### 코드 분석

<details markdown="1">

<summary>전체 코드</summary>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;

    mapping(address => uint256) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
```

</details>

간단하게 `owner` 탈취하면 되는데 엥?? 와이리 쉽노..
<br>

---

### 풀이

```solidity
function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
}
```

다른 부분 볼 필요 없이 이 부분만 보면 된다  

주석에는 constructor로 되어 있지만 메소드로 정의되어 있기 때문에 호출만 하면 `owner` 탈취가 가능하다..
<br>

---

![Image](/assets/img/250801_0/3.png)

<br>

---

### 외전

문제를 풀고 나면 Rubixi라는 컨트랙트의 이야기가 나온다  
<br>

---

```solidity
contract Rubixi {
    address private creator;

    function DynamicPyramid() public {
        creator = msg.sender;
    }
}
```

이더리움 초창기에 Rubixi라는 컨트랙트가 있었다  
사실 폰지 사기 구조를 가진 컨트랙트였다  

위처럼 0.4.22 버전 이전까지는 constructor의 이름이 컨트랙트 이름과 동일해야 했다  
하지만 개발자가 컨트랙트 이름을 Rubixi로 바꿨지만 constuctor의 이름을 그대로 두면서 취약점이 생겼다  

creator가 초기 배포자가 아닌 호출한 사람의 주소가 되어 버려서 아무나 수수료를 탈취할 수 있었다  

