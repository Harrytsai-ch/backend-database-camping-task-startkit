-- 1.1
INSERT INTO "USER"(name, email, role) VALUES
	('李燕容','lee2000@hexschooltest.io','USER'),
	('王小明','wXlTq@hexschooltest.io','USER'),
	('肌肉棒子','muscle@hexschooltest.io','USER'),
	('好野人','richman@hexschooltest.io','USER'),
	('Q太郎','starplatinum@hexschooltest.io','USER'),
	('透明人','opacity0@hexschooltest.io','USER');


-- 1-2 修改：用 Email 找到 李燕容、肌肉棒子、Q太郎，如果他的 Role 為 USER 將他的 Role 改為 COACH
UPDATE "USER"
SET role = 'COACH'
WHERE email in ('lee2000@hexschooltest.io','muscle@hexschooltest.io','starplatinum@hexschooltest.io');

-- 1-3 刪除：刪除USER 資料表中，用 Email 找到透明人，並刪除該筆資料
DELETE FROM "USER"
WHERE email = 'opacity0@hexschooltest.io';

-- 1-4 查詢：取得USER 資料表目前所有用戶數量（提示：使用count函式）
SELECT count(*) FROM "USER";

-- 1-5 查詢：取得 USER 資料表所有用戶資料，並列出前 3 筆（提示：使用limit語法）
SELECT * FROM "USER" limit 3;

-- 2. 組合包方案 CREDIT_PACKAGE、客戶購買課程堂數 CREDIT_PURCHASE
-- 2-1. 新增：在`CREDIT_PACKAGE` 資料表新增三筆資料，資料需求如下：
    -- 1. 名稱為 `7 堂組合包方案`，價格為`1,400` 元，堂數為`7`
    -- 2. 名稱為`14 堂組合包方案`，價格為`2,520` 元，堂數為`14`
    -- 3. 名稱為 `21 堂組合包方案`，價格為`4,800` 元，堂數為`21`

INSERT INTO "CREDIT_PACKAGE"(name, price, credit_amount) VALUES
	('7 堂組合包方案',1400,7),
	('14 堂組合包方案',2520,14),
	('21 堂組合包方案',4800,21);

-- 2-2. 新增：在 `CREDIT_PURCHASE` 資料表，新增三筆資料：（請使用 name 欄位做子查詢）
--->.     user.id, credit_package_id
    -- 1. `王小明` 購買 `14 堂組合包方案`(2)
    -- 2. `王小明` 購買 `21 堂組合包方案`(3)
    -- 3. `好野人` 購買 `14 堂組合包方案`(2)

INSERT INTO "CREDIT_PURCHASE"(user_id, credit_package_id, purchased_credits, price_paid) VALUES
	(
	(SELECT u.id FROM "USER" u WHERE u.name = '王小明'), 
	(SELECT cp.id FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' ), 
	(SELECT cp.credit_amount FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' ), 
	(SELECT cp.price FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' )),
	(
	(SELECT u.id FROM "USER" u WHERE u.name = '王小明'), 
	(SELECT cp.id FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '21 堂組合包方案' ), 
	(SELECT cp.credit_amount FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '21 堂組合包方案' ), 
	(SELECT cp.price FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '21 堂組合包方案' )
	),
	(
	(SELECT u.id FROM "USER" u WHERE u.name = '好野人'), 
	(SELECT cp.id FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' ),
	(SELECT cp.credit_amount FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' ), 
	(SELECT cp.price FROM  "CREDIT_PACKAGE" cp WHERE cp.name = '14 堂組合包方案' )
	);

-- 3. 教練資料 ，資料表為 COACH ,SKILL,COACH_LINK_SKILL
-- 3-1 新增：在`COACH`資料表新增三筆教練資料，資料需求如下：
    -- 1. 將用戶`李燕容`新增為教練，並且年資設定為2年（提示：使用`李燕容`的email ，取得 `李燕容` 的 `id` ）
    -- 2. 將用戶`肌肉棒子`新增為教練，並且年資設定為2年
    -- 3. 將用戶`Q太郎`新增為教練，並且年資設定為2年
INSERT INTO "COACH"(user_id, experience_years) VALUES 
((SELECT u.id FROM "USER" u WHERE u.email ='lee2000@hexschooltest.io'),2),
((SELECT u.id FROM "USER" u WHERE u.email ='muscle@hexschooltest.io'),2),
((SELECT u.id FROM "USER" u WHERE u.email ='starplatinum@hexschooltest.io'),2);


-- 3-2. 新增：承1，為三名教練新增專長資料至 `COACH_LINK_SKILL` ，資料需求如下：
    -- 1. 所有教練都有 `重訓` 專長
    -- 2. 教練`肌肉棒子` 需要有 `瑜伽` 專長
    -- 3. 教練`Q太郎` 需要有 `有氧運動` 與 `復健訓練` 專長

-- INSERT INTO ... SELECT 是更簡潔的做法
INSERT INTO "COACH_LINK_SKILL"(coach_id, skill_id) 
	SELECT c.id, s.id 
	FROM "SKILL" s 
	CROSS JOIN "COACH" c 
	WHERE (s.name = '重訓')
	OR (s.name = '瑜伽' AND c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '肌肉棒子'))
	OR (s.name in ('有氧運動','復健訓練') AND c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = 'Q太郎'));

-- 3-3 修改：更新教練的經驗年數，資料需求如下：
    -- 1. 教練`肌肉棒子` 的經驗年數為3年
    -- 2. 教練`Q太郎` 的經驗年數為5年

UPDATE "COACH" c
SET experience_years = 3
WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '肌肉棒子');


UPDATE "COACH" c
SET experience_years = 5
WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = 'Q太郎');

-- 3-4 刪除：新增一個專長 空中瑜伽 至 SKILL 資料表，之後刪除此專長。

INSERT INTO "SKILL" (name) VALUES
('空中瑜伽');

DELETE FROM "SKILL"
WHERE name = '空中瑜伽';

-- 4. 課程管理 COURSE 、組合包方案 CREDIT_PACKAGE

-- 4-1. 新增：在`COURSE` 新增一門課程，資料需求如下：
    -- 1. 教練設定為用戶`李燕容` 
    -- 2. 在課程專長 `skill_id` 上設定為「 `重訓` 」
    -- 3. 在課程名稱上，設定為「`重訓基礎課`」
    -- 4. 授課開始時間`start_at`設定為2024-11-25 14:00:00
    -- 5. 授課結束時間`end_at`設定為2024-11-25 16:00:00
    -- 6. 最大授課人數`max_participants` 設定為10
    -- 7. 授課連結設定`meeting_url`為 https://test-meeting.test.io

INSERT INTO "COURSE"(user_id, skill_id, name, start_at, end_at, max_participants, meeting_url) 
VALUES(
	(SELECT u.id FROM "USER" u WHERE u.name = '李燕容'), 
	(SELECT s.id FROM "SKILL" s WHERE s.name = '重訓'), 
	'重訓基礎課',
	TO_TIMESTAMP('2024-11-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
	TO_TIMESTAMP('2024-11-25 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
	10,
	'https://test-meeting.test.io'
);



-- 5. 客戶預約與授課 COURSE_BOOKING
-- 5-1. 新增：請在 `COURSE_BOOKING` 新增兩筆資料：
    -- 1. 第一筆：`王小明`預約 `李燕容` 的課程
        -- 1. 預約人設為`王小明`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課
    -- 2. 新增： `好野人` 預約 `李燕容` 的課程
        -- 1. 預約人設為 `好野人`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課

INSERT INTO "COURSE_BOOKING"(user_id, course_id, booking_at, status)
VALUES
	(
	 (SELECT u.id FROM "USER" u WHERE u.name = '王小明'),
	 (SELECT c.id FROM "COURSE" c WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '李燕容')),
	 TO_TIMESTAMP('2024-11-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
	 '即將授課');

INSERT INTO "COURSE_BOOKING"(user_id, course_id, booking_at, status)
VALUES
	 (
	 (SELECT u.id FROM "USER" u WHERE u.name = '好野人'), 
	 (SELECT c.id FROM "COURSE" c WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '李燕容')),
	 TO_TIMESTAMP('2024-11-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
	 '即將授課'
	 );

-- 5-2. 修改：`王小明`取消預約 `李燕容` 的課程，請在`COURSE_BOOKING`更新該筆預約資料：
    -- 1. 取消預約時間`cancelled_at` 設為2024-11-24 17:00:00
    -- 2. 狀態`status` 設定為課程已取消

UPDATE "COURSE_BOOKING"
SET cancelled_at = TO_TIMESTAMP('2024-11-24 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), status = '課程已取消'
WHERE user_id = (SELECT u.id FROM "USER" u WHERE u.name = '王小明');

-- 5-3. 新增：`王小明`再次預約 `李燕容`   的課程，請在`COURSE_BOOKING`新增一筆資料：
    -- 1. 預約人設為`王小明`
    -- 2. 預約時間`booking_at` 設為2024-11-24 17:10:25
    -- 3. 狀態`status` 設定為即將授課

INSERT INTO "COURSE_BOOKING"(user_id, course_id, booking_at, status)
VALUES
	(
	 (SELECT u.id FROM "USER" u WHERE u.name = '王小明'),
	 (SELECT c.id FROM "COURSE" c WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '李燕容')),
	 TO_TIMESTAMP('2024-11-24 17:10:25', 'YYYY-MM-DD HH24:MI:SS'),
	 '即將授課');


-- 5-4. 查詢：取得王小明所有的預約紀錄，包含取消預約的紀錄

SELECT * 
FROM "COURSE_BOOKING" c
WHERE c.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '王小明');


-- 5-5. 修改：`王小明` 現在已經加入直播室了，請在`COURSE_BOOKING`更新該筆預約資料（請注意，不要更新到已經取消的紀錄）：
    -- 1. 請在該筆預約記錄他的加入直播室時間 `join_at` 設為2024-11-25 14:01:59
    -- 2. 狀態`status` 設定為上課中

UPDATE "COURSE_BOOKING"
SET join_at = TO_TIMESTAMP('2024-11-25 14:01:59', 'YYYY-MM-DD HH24:MI:SS'), status = '上課中'
WHERE status = '即將授課' AND user_id = (SELECT u.id FROM "USER" u WHERE u.name = '王小明');


-- 5-6. 查詢：計算用戶王小明的購買堂數，顯示須包含以下欄位： user_id , total。 (需使用到 SUM 函式與 Group By)
SELECT c.user_id ,SUM(c.purchased_credits) AS total 
FROM "CREDIT_PURCHASE" c
GROUP BY 1
HAVING user_id =(SELECT u.id FROM "USER" u WHERE u.name = '王小明');

-- 5-7. 查詢：計算用戶王小明的已使用堂數，顯示須包含以下欄位： user_id , total。 (需使用到 Count 函式與 Group By)
SELECT user_id , count(*) AS total
FROM "COURSE_BOOKING"
WHERE user_id =(SELECT u.id FROM "USER" u WHERE u.name = '王小明') AND status = '上課中'
GROUP BY 1;

-- 5-8. [挑戰題] 查詢：請在一次查詢中，計算用戶王小明的剩餘可用堂數，顯示須包含以下欄位： user_id , remaining_credit
    -- 提示：
	-- 拆成數個子問題：1.先取得王小明購買的所有堂數 2.取得王小明已經上課的堂數 3.計剩餘堂數
    -- select ("CREDIT_PURCHASE".total_credit - "COURSE_BOOKING".used_credit) as remaining_credit, ...
    -- from ( 用戶王小明的購買堂數 ) as "CREDIT_PURCHASE"
    -- inner join ( 用戶王小明的已使用堂數) as "COURSE_BOOKING"
    -- on "COURSE_BOOKING".user_id = "CREDIT_PURCHASE".user_id;

SELECT ROW_NUMBER() over (order by c3.remaining_credit) ,c3.user_id , c3.remaining_credit
FROM(
	SELECT c1.user_id , c2.credit_use_count , SUM(c1.purchased_credits) - c2.credit_use_count as remaining_credit
	FROM "CREDIT_PURCHASE" c1
	JOIN (
		SELECT user_id , count(*) AS credit_use_count
		FROM "COURSE_BOOKING"
		WHERE user_id =(SELECT u.id FROM "USER" u WHERE u.name = '王小明') AND status = '上課中'
		GROUP BY 1
		) c2
	on c1.user_id = c2.user_id
	WHERE c1.user_id = (SELECT u.id FROM "USER" u WHERE u.name = '王小明')
	GROUP BY 1,2
) c3;

-- 6-1. 查詢：查詢專長為 重訓 的教練，並按經驗年數排序，由資深到資淺（需使用 inner join 與 order by 語法)，顯示須包含以下欄位： 教練名稱 , 經驗年數, 專長名稱
SELECT u.name AS "教練名稱", 
f.experience_years AS "經驗年數",
f.name AS "專長名稱"
FROM "USER" u
INNER JOIN
	(
	SELECT c.user_id, c.experience_years, f.name FROM "COACH" c
	INNER JOIN 
		(SELECT cls.coach_id,s.name FROM "COACH_LINK_SKILL" cls
		INNER JOIN "SKILL" s
		ON cls.skill_id = s.id
		WHERE  s.name = '重訓') f
	ON f.coach_id = c.id
	) as f
ON f.user_id = u.id
ORDER BY "經驗年數" DESC;


-- 6-2. 查詢：查詢每種專長的教練數量，並只列出教練數量最多的專長（需使用 group by, inner join 與 order by 與 limit 語法），顯示須包含以下欄位： 專長名稱, coach_total
SELECT f.name , COUNT(*)
FROM(
	SELECT c.user_id, f.name FROM "COACH" c
	INNER JOIN 
		(SELECT cls.coach_id,s.name FROM "COACH_LINK_SKILL" cls
		INNER JOIN "SKILL" s
		ON cls.skill_id = s.id
		) f
	ON f.coach_id = c.id ) f
GROUP by 1
ORDER by 2 DESC
limit 1;

-- 6-3. 查詢：計算 11 月份組合包方案的銷售數量，顯示須包含以下欄位： 組合包方案名稱, 銷售數量
SELECT cp1.name, COUNT(*)  FROM "CREDIT_PACKAGE" cp1
INNER JOIN "CREDIT_PURCHASE" cp2
on cp2.credit_package_id = cp1.id
WHERE TO_CHAR(cp2.purchase_at,'YYYYMM') = '202411'
GROUP BY 1;


-- 6-4. 查詢：計算 11 月份總營收（使用 purchase_at 欄位統計），顯示須包含以下欄位： 總營收
SELECT SUM(price_paid) FROM  "CREDIT_PURCHASE"
WHERE TO_CHAR(purchase_at,'YYYYMM') = '202411'


-- 6-5. 查詢：計算 11 月份有預約課程的會員人數（需使用 Distinct，並用 created_at 和 status 欄位統計），顯示須包含以下欄位： 預約會員人數
SELECT COUNT(DISTINCT(user_id)) FROM "COURSE_BOOKING"
WHERE  TO_CHAR(created_at,'YYYYMM') = '202411' AND status not in ('課程已取消');
