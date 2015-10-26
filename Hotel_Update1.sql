SET ECHO ON
SET SCAN OFF

DROP TABLE UserID;
DROP TABLE ITEM_PRICE;
DROP SEQUENCE seq_hotel_system;
ALTER TABLE STAY DROP COLUMN STATUS;

--Number 1.
CREATE TABLE UserId
(
  UserId VARCHAR2(20 BYTE) NOT NULL,
  Password VARCHAR2(20 BYTE),
  Hotel_ID NUMBER NOT NULL,
  Last_Name VARCHAR2(30 BYTE),
  First_Name VARCHAR2(30 BYTE)
);
CREATE UNIQUE INDEX PK_UserId on UserId (UserId);
ALTER TABLE UserId ADD( CONSTRAINT PK_UserId PRIMARY KEY(UserId));
ALTER TABLE UserId ADD( CONSTRAINT FK_Hotel_ID FOREIGN KEY (Hotel_ID) REFERENCES HOTEL(HOTEL_ID));
INSERT INTO USERID(USERID,PASSWORD,HOTEL_ID,LAST_NAME,FIRST_NAME) VALUES('Bradley','oracle',1,'Bradley','Louis');

--Number 2.
CREATE SEQUENCE seq_hotel_system
START WITH 100
INCREMENT BY 1
NOCYCLE;

SET DEFINE OFF
CREATE OR REPLACE TRIGGER GUEST_SEQ BEFORE INSERT ON Guest FOR EACH ROW
BEGIN
:NEW.GUEST_ID:=SEQ_HOTEL_SYSTEM.NEXTVAL;
END;
/
SET DEFINE OFF
CREATE OR REPLACE TRIGGER HOTEL_SEQ BEFORE INSERT ON HOTEL FOR EACH ROW
BEGIN
:NEW.HOTEL_ID:=SEQ_HOTEL_SYSTEM.NEXTVAL;
END;
/
SET DEFINE OFF
CREATE OR REPLACE TRIGGER STAY_SEQ BEFORE INSERT ON STAY FOR EACH ROW
BEGIN
:NEW.STAY_ID:=SEQ_HOTEL_SYSTEM.NEXTVAL;
END;
/
SET DEFINE OFF
CREATE OR REPLACE TRIGGER SALES_ITEM_SEQ BEFORE INSERT ON SALES_ITEM FOR EACH ROW
BEGIN
:NEW.ITEM_ID:=SEQ_HOTEL_SYSTEM.NEXTVAL;
END;
/
SET DEFINE OFF
CREATE OR REPLACE TRIGGER CHARGE_SEQ BEFORE INSERT ON CHARGE 
REFERENCING New AS NEW Old AS OLD 
FOR EACH ROW
BEGIN
:NEW.CHARGE_ID:=SEQ_HOTEL_SYSTEM.NEXTVAL;
END;
/

--Number 3.
CREATE TABLE ITEM_PRICE
(
  ITEM_ID NUMBER NOT NULL,
  HOTEL_ID NUMBER NOT NULL,
  ITEM_PRICE NUMBER
);
CREATE UNIQUE INDEX PK_ITEM_PRICE ON ITEM_PRICE(ITEM_ID,HOTEL_ID);
ALTER TABLE ITEM_PRICE ADD( CONSTRAINT FK_ITEM_PRICE__HOTEL FOREIGN KEY (HOTEL_ID) REFERENCES HOTEL(HOTEL_ID));
ALTER TABLE ITEM_PRICE ADD( CONSTRAINT FK_ITEM_PRICE__ITEM FOREIGN KEY (ITEM_ID) REFERENCES SALES_ITEM(ITEM_ID));
INSERT ALL
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,1,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,2,200)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,3,40)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,4,50)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,5,10)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(1,6,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,1,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,2,200)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,3,40)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,4,50)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,5,10)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(2,6,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,1,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,2,200)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,3,40)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,4,50)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,5,10)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(3,6,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,1,100)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,2,200)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,3,40)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,4,50)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,5,10)
 INTO ITEM_PRICE(HOTEL_ID,ITEM_ID,ITEM_PRICE) VALUES(4,6,100)
 SELECT * FROM dual;
 COMMIT;
 
--Number 4.
ALTER TABLE STAY ADD(STATUS VARCHAR2(1 Byte));
UPDATE STAY SET STATUS='O';
COMMIT;

--Number 5.

--Number 6.
CREATE OR REPLACE PROCEDURE HOTELLOGIN(HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2)
AS URL VARCHAR2(100):='"http://dboracle.eng.fau.edu:7777/~mpetros2/Hotel.HTML"';
GRANTACCESS NUMBER;
CURRENTHOTEL VARCHAR2(50 BYTE);
CHOTELID NUMBER;
HFIRSTNAME VARCHAR2(30 BYTE);
HLASTNAME VARCHAR2(30 BYTE);
BEGIN
SELECT COUNT(*) INTO GRANTACCESS FROM USERID WHERE USERID=HUSERID AND PASSWORD=HPASSWORD;
IF(GRANTACCESS>0)
THEN
SELECT HOTEL_ID INTO CHOTELID FROM USERID WHERE USERID=HUSERID;
SELECT HOTEL_NAME INTO CURRENTHOTEL FROM HOTEL WHERE HOTEL_ID=CHOTELID;
SELECT LAST_NAME INTO HLASTNAME FROM USERID WHERE USERID=HUSERID;
SELECT FIRST_NAME INTO HFIRSTNAME FROM USERID WHERE USERID=HUSERID;
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css">
<title>Welcome to the '||CURRENTHOTEL||' hotel, '||HFIRSTNAME||' '||HLASTNAME||'</title></head><body>
<a href="../any/CheckInComboBox?inHotelID='||CHOTELID||'&HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Guest Check-In</a></br></br>
<a href="../any/ChargeComboBox?inHotelID='||CHOTELID||'&HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'&inStayID='||NULL||'&inItemID='||NULL||'&inQuantity='||NULL||'">Add Charge To Guest</a></br></br>
<a href="../any/GuestFolio?inHotelID='||CHOTELID||'&HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Retrieve Guest Folio</a></br></br>
<a href="../~mpetros2/Hotel.HTML">Logoff</a>');
ELSE
HTP.PRINT('<h1>Invalid user and password combination</h1><a href="../~mpetros2/Hotel.HTML">Retry login</a>');
END IF;
HTP.PRINT('</body></html>');
END;
/

--Number 7.
CREATE OR REPLACE PROCEDURE CHECKINCOMBOBOX (inHotelID IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2) AS
BEGIN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Check in a guest</title></head><body>
<form id="guestcheck" action="../any/CheckIn" method="get">Select a guest to check in: <select form="guestcheck" name="inGuestID">');
FOR dbEachGuest IN (SELECT GUEST.GUEST_ID,LAST_NAME,FIRST_NAME FROM GUEST)
LOOP
HTP.PRINT('<option value="'||dbEachGuest.Guest_ID||'" name="inGuestID">'||dbEachGuest.Last_name||', '||dbEachGuest.First_Name||'</option>');
END LOOP;
HTP.PRINT('</select><p>Enter the number of rooms: <input type="text" name="inRoom"></p>
<p>Enter the number of days to stay: <input type="text" name="inDays"></p>
<input type="hidden" name="inHotelID" value="'||inHotelID||'">
<input type="hidden" name="HUSERID" value="'||HUSERID||'">
<input type="hidden" name="HPASSWORD" value="'||HPASSWORD||'">
<p>
<input type="submit" value="Check in guest"/></p></form>
<script language="JavaScript">function getParm(string,parm){var startPos=string.indexOf(parm+"=");
if(startPos>-1){startPos=startPos+parm.length+1;var endPos=string.indexOf("&",startPos);
if(endPos==-1)
endPos=string.length;return unescape(string.substring(startPos,endPos));}
return'';}
var passed=location.search.substring(1);
document.addguest.HUSERID.value=getParm(passed,''HUSERID'');
document.addguest.HPASSWORD.value=getParm(passed,''HPASSWORD'');</script>

<a href="../~mpetros2/AddGuest.HTML" onclick="location.href=this.href+''?HUSERID=''getParm(passed,''HUSERID'');''+''&HPASSWORD=''getParm(passed,''HPASSWORD'');">Add a guest</a></br></br>
<a href="../any/HotelLogin?HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Return to main menu</a></body></html>');
END;
/

CREATE OR REPLACE PROCEDURE CHECKIN (inHotelID IN NUMBER, inGuestID IN NUMBER, inRoom IN NUMBER, inDays IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2) AS
BEGIN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Check in guest</title></head><body>');
INSERT INTO STAY(GUEST_ID,HOTEL_ID,START_DATE,NUMBER_DAYS,ROOM,STATUS) VALUES(inGuestID,inHotelID,SYSDATE,inDays,inRoom,'I');
COMMIT;
HTP.PRINT('<h2>Guest has been checked in!</h2>');
HTP.PRINT('<a href="../any/CheckInComboBox?inHotelID='||inHOTELID||'&HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Check in another guest</a></br></br><a href="../any/HotelLogin?HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Return to main menu</a>
</body></html>');
EXCEPTION
WHEN OTHERS THEN HTP.PRINT('Charge insertion has failed!'||SQLERRM||' '||SQLCODE);
END;
/

--Number 8.
CREATE OR REPLACE PROCEDURE ADDGUEST(inFirstName IN VARCHAR2,inLastName IN VARCHAR2,inCity IN VARCHAR2, inLoyalID IN VARCHAR2) AS
BEGIN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Add guest</title></head><body>');
INSERT INTO GUEST(LAST_NAME,FIRST_NAME,CITY,LOYALTY_NUMBER) VALUES (inFirstName,inLastName,inCity,inLoyalID);
COMMIT;
HTP.PRINT(inFirstName||' '||inLastName||' has been added as a guest!');
HTP.PRINT('<p><a href="../~mpetros2/AddGuest.HTML">Add a guest</a></br></br>
<a href="../~mpetros2/Hotel.HTML">Return to main menu</a></p></body></html>');
EXCEPTION
WHEN OTHERS THEN HTP.PRINT('<h2>The guest could not be entered. '||SQLERRM||' '||SQLCODE||'</h2></br>');
END;
/

--Number 9.
CREATE OR REPLACE PROCEDURE CHARGECOMBOBOX(inHotelID IN NUMBER, inStayID IN NUMBER, inItemID IN NUMBER, inQuantity IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2) AS
STAYEXISTS NUMBER;
CURRENTHOTEL VARCHAR2(50 BYTE);
ITEMPRICE NUMBER;
BEGIN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Add a charge</title></head><body>');
SELECT HOTEL_NAME INTO CURRENTHOTEL FROM HOTEL WHERE HOTEL_ID=inHotelID;
SELECT COUNT(*) INTO STAYEXISTS FROM GUEST,STAY,HOTEL WHERE STATUS='I' AND STAY.GUEST_ID=GUEST.GUEST_ID AND STAY.HOTEL_ID=HOTEL.HOTEL_ID AND HOTEL.HOTEL_ID=inHotelID;
IF(STAYEXISTS<1)
THEN HTP.PRINT('<h1>No guests have been checked into the '||CURRENTHOTEL||' hotel!</h1></body></html>');
ELSE
HTP.PRINT('<form id="inscharge" action="../any/ChargeComboBox" method="get">
Select a guest currently in a hotel: <select form="inscharge" name="inStayID">');
FOR dbEachGuest IN (SELECT STAY_ID,LAST_NAME,FIRST_NAME,HOTEL_NAME FROM GUEST,STAY,HOTEL WHERE STATUS='I' AND STAY.GUEST_ID=GUEST.GUEST_ID AND STAY.HOTEL_ID=HOTEL.HOTEL_ID AND HOTEL.HOTEL_ID=inHotelID)
LOOP
HTP.PRINT('<option value="'||dbEachGuest.Stay_ID||'" >'||dbEachGuest.Last_Name||', '||dbEachGuest.First_Name||': '||dbEachGuest.Hotel_Name||'</option>');
END LOOP;
HTP.PRINT('</select></br></br>Choose an item to buy at a hotel: <select form="inscharge" name="inItemID">');
FOR dbEachCharge IN (SELECT ITEM_PRICE.ITEM_ID,ITEM_NAME,ITEM_PRICE,HOTEL_NAME FROM SALES_ITEM,ITEM_PRICE,HOTEL WHERE ITEM_PRICE.HOTEL_ID=HOTEL.HOTEL_ID AND ITEM_PRICE.ITEM_ID=SALES_ITEM.ITEM_ID AND HOTEL.HOTEL_ID=inHotelID)
LOOP
HTP.PRINT('<option value="'||dbEachCharge.Item_ID||'">'||dbEachCharge.Item_Name||' for $'||dbEachCharge.Item_Price||/*' at '||dbEachCharge.HOTEL_NAME||*/'</option>');
END LOOP;
HTP.PRINT('</select></br></br>Enter the quantity: <input type="text" name="inQuantity" size="4">
<input type="hidden" name="inHotelID" value="'||inHotelID||'"><input type="hidden" name="HUSERID" value="'||HUSERID||'">
<input type="hidden" name="HPASSWORD" value="'||HPASSWORD||'"><input type="submit" value="Add charge">');

IF(inItemID != 0 AND inStayID != 0)
THEN
InsertCharge(inHotelID,inStayID,inItemID,inQuantity,HUSERID,HPASSWORD);
END IF;

END IF;
HTP.PRINT('</br><a href="../any/HotelLogin?HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Return to main menu</a></body></html>');
END;
/

CREATE OR REPLACE PROCEDURE INSERTCHARGE (inHotelID IN NUMBER, inStayID IN NUMBER, inItemID IN NUMBER, inQuantity IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2) AS
ITEMPRICE NUMBER;
BEGIN
SELECT ITEM_PRICE INTO ITEMPRICE FROM ITEM_PRICE WHERE HOTEL_ID=inHotelID AND ITEM_ID=inItemID;
INSERT INTO CHARGE(ITEM_ID,STAY_ID,QUANTITY,UNIT_PRICE,TRANS_DATE) VALUES(inItemID,inStayID,inQuantity,ITEMPRICE,SYSDATE);
COMMIT;
HTP.PRINT('<h2>The charge for the guest has been added!</h2>');
GetFolio(inStayID, inHotelID,HUSERID,HPASSWORD,1);
EXCEPTION
WHEN OTHERS THEN HTP.PRINT('Charge insertion has failed!'||SQLERRM||' '||SQLCODE);
END;
/

--Number 10.
CREATE OR REPLACE PROCEDURE GUESTFOLIO(inHotelID IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2) AS
STAYEXISTS NUMBER;
BEGIN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Retrieve your guest folio</title></head><body>');
SELECT COUNT(*) INTO STAYEXISTS FROM GUEST,STAY WHERE GUEST.GUEST_ID=STAY.GUEST_ID AND HOTEL_ID=inHotelID;
IF(STAYEXISTS < 1)
THEN
HTP.PRINT('<h2>No charge records for the guest have been found!</h2>');
ELSE
HTP.PRINT('<form id="getfolio" action="../any/GetFolio" method="get">Select a guest folio to locate: <select form="getfolio" name="inStayID">');
FOR dbEachGuest IN (SELECT STAY_ID,LAST_NAME,FIRST_NAME,START_DATE FROM GUEST,STAY WHERE GUEST.GUEST_ID=STAY.GUEST_ID AND HOTEL_ID=inHotelID)
LOOP
HTP.PRINT('<option value="'||dbEachGuest.Stay_ID||'">'||dbEachGuest.Last_name||', '||dbEachGuest.First_Name||': '||dbEachGuest.Start_Date||'</option>');
END LOOP;
HTP.PRINT('</select><p><input type="hidden" name="inHotelID" value="'||inHotelID||'">
<input type="hidden" name="HUSERID" value="'||HUSERID||'">
<input type="hidden" name="HPASSWORD" value="'||HPASSWORD||'">
<input type="hidden" name="ISCHARGE" value="0">
<input type="submit" value="Retrieve folio"/></p></br>
<a href="../any/HotelLogin?HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Return to main menu</a></body></html>');
END IF;
END;
/

CREATE OR REPLACE PROCEDURE GETFOLIO(inStayID IN NUMBER, inHotelID IN NUMBER,HUSERID IN VARCHAR2,HPASSWORD IN VARCHAR2,ISCHARGE IN NUMBER) AS
FULLNAME VARCHAR(60 BYTE);
CHARGEEXISTS NUMBER;
BEGIN
IF(ISCHARGE != 1)
THEN
HTP.PRINT('<html><head><link rel="stylesheet" type="text/css" href="../~mpetros2/default.css"><title>Guest folio retrieval</title></head><body>');
END IF;
HTP.PRINT('<p>');
SELECT COUNT(*) INTO CHARGEEXISTS FROM CHARGE,SALES_ITEM WHERE STAY_ID=inStayID AND CHARGE.ITEM_ID=SALES_ITEM.ITEM_ID;
IF(CHARGEEXISTS>0)
THEN
HTP.PRINT('<table><tr><th>Guest name</th><th>Transaction date</th><th>Item ID</th><th>Item name</th><th>Quantity</th><th>Unit price</th><th>Taxable</th><th>Extended price</th></tr>');
SELECT LAST_NAME||', '||FIRST_NAME INTO FULLNAME FROM GUEST,STAY WHERE GUEST.GUEST_ID=STAY.GUEST_ID AND STAY_ID=INSTAYID;
FOR DBEACHSTAY IN (SELECT TRANS_DATE,CHARGE.ITEM_ID,ITEM_NAME,QUANTITY,UNIT_PRICE,TAXABLE,QUANTITY*UNIT_PRICE AS EXTPRICE FROM CHARGE,SALES_ITEM WHERE STAY_ID=inStayID
AND CHARGE.ITEM_ID=SALES_ITEM.ITEM_ID)
LOOP
HTP.PRINT('<tr><td>'||FULLNAME||'</td><td>'||DBEACHSTAY.TRANS_DATE||'</td><td>'||DBEACHSTAY.ITEM_ID||'</td>
<td>'||DBEACHSTAY.ITEM_NAME||'</td><td>'||DBEACHSTAY.QUANTITY||'</td><td>$'||DBEACHSTAY.UNIT_PRICE||'</td><td>'||DBEACHSTAY.TAXABLE||'</td>
<td>$'||DBEACHSTAY.EXTPRICE||'</td></tr>');
END LOOP;
HTP.PRINT('</table></p>');
ELSE
HTP.PRINT('<h2>No charge records for the guest have been found!</h2>');
END IF;
IF(ISCHARGE != 1)
THEN
HTP.PRINT('<p><a href="../any/GuestFolio?inHotelID='||inHotelID||'&huserid='||HUSERID||'&hpassword='||HPASSWORD||'">Retrieve another guest folio</a><br>
<a href="../any/HotelLogin?HUSERID='||HUSERID||'&HPASSWORD='||HPASSWORD||'">Return to main menu</a></p></body></html>');
END IF;
END;
/