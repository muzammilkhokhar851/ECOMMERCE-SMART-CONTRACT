// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

 contract Ecommerce{

     struct Product{
         string title;
         string description;
         address payable seller;
         uint productID;
         uint price;
         address buyer;
         bool delivered;
     }

     uint counter =1;

/*array of structure to register different products*/
     Product[] public products; 
     event registered(string title, uint prodrctID, address seller);
     event bought(uint prodrctID, address buyer);
     event delivered(uint productID);

     function registerProduct(string memory _title, string memory _desc, uint _price) public{
         require(_price>0,"Price should be greater than zero.");
         Product memory tempProduct;
         tempProduct.title =_title;
         tempProduct.description =_desc;
         tempProduct.price = _price * 10**18;
         tempProduct.seller = payable(msg.sender);
         tempProduct.productID = counter;
         products.push(tempProduct);
         counter++;
         emit registered(_title,tempProduct.productID,msg.sender);  
     } 


     function buy(uint _productID) payable public{
         require(products[_productID-1].price==msg.value,"Please pay the excat price.");
         require(products[_productID-1].seller!=msg.sender,"Seller cannot be the buyer.");
         products[_productID-1].buyer=msg.sender;
         emit bought(_productID,msg.sender);
     }


     function delivery(uint _productID) public{
         require(products[_productID-1].buyer==msg.sender,"Only buyer can confirm delivery");
         products[_productID-1].delivered=true;
         products[_productID-1].seller.transfer(products[_productID-1].price);
         emit delivered(_productID);
     }


 }