-- ============================================================
-- HW4 — LibraryManagement + Northwind JOINs
-- ============================================================

-- ============================================================
-- Завдання 1 — Схема LibraryManagement
-- ============================================================

DROP DATABASE IF EXISTS LibraryManagement;
CREATE DATABASE LibraryManagement CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE LibraryManagement;

CREATE TABLE authors (
    author_id   INT          NOT NULL AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (author_id)
);

CREATE TABLE genres (
    genre_id   INT          NOT NULL AUTO_INCREMENT,
    genre_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (genre_id)
);

CREATE TABLE books (
    book_id          INT          NOT NULL AUTO_INCREMENT,
    title            VARCHAR(255) NOT NULL,
    publication_year YEAR,
    author_id        INT,
    genre_id         INT,
    PRIMARY KEY (book_id),
    CONSTRAINT fk_books_author
        FOREIGN KEY (author_id) REFERENCES authors (author_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_books_genre
        FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE users (
    user_id  INT          NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email    VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE borrowed_books (
    borrow_id   INT  NOT NULL AUTO_INCREMENT,
    book_id     INT  NOT NULL,
    user_id     INT  NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    PRIMARY KEY (borrow_id),
    CONSTRAINT fk_bb_book
        FOREIGN KEY (book_id) REFERENCES books (book_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_bb_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ============================================================
-- Завдання 2 — Тестові дані
-- ============================================================

INSERT INTO authors (author_name) VALUES
    ('George Orwell'),
    ('Frank Herbert');

INSERT INTO genres (genre_name) VALUES
    ('Dystopia'),
    ('Science Fiction');

INSERT INTO books (title, publication_year, author_id, genre_id) VALUES
    ('1984',         1949, 1, 1),
    ('Dune',         1965, 2, 2);

INSERT INTO users (username, email) VALUES
    ('john_doe',  'john@example.com'),
    ('jane_smith','jane@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES
    (1, 1, '2026-05-01', '2026-05-15'),
    (2, 2, '2026-05-05', NULL);

-- ============================================================
-- Завдання 3 — Northwind: INNER JOIN всіх 8 таблиць
-- ============================================================

USE northwind;

SELECT
    od.id            AS detail_id,
    od.quantity,
    o.id             AS order_id,
    o.date           AS order_date,
    c.name           AS customer,
    p.name           AS product,
    cat.name         AS category,
    e.first_name,
    e.last_name,
    s.name           AS shipper,
    sup.name         AS supplier
FROM order_details od
INNER JOIN orders     o   ON od.order_id   = o.id
INNER JOIN customers  c   ON o.customer_id = c.id
INNER JOIN products   p   ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees  e   ON o.employee_id = e.employee_id
INNER JOIN shippers   s   ON o.shipper_id  = s.id
INNER JOIN suppliers  sup ON p.supplier_id = sup.id;

-- ============================================================
-- Завдання 4а — Кількість рядків (COUNT)
-- ============================================================

SELECT COUNT(*) AS total_rows
FROM order_details od
INNER JOIN orders     o   ON od.order_id   = o.id
INNER JOIN customers  c   ON o.customer_id = c.id
INNER JOIN products   p   ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees  e   ON o.employee_id = e.employee_id
INNER JOIN shippers   s   ON o.shipper_id  = s.id
INNER JOIN suppliers  sup ON p.supplier_id = sup.id;

-- ============================================================
-- Завдання 4б — LEFT / RIGHT JOIN замість INNER JOIN
-- (замінюємо JOIN з customers та shippers на LEFT/RIGHT)
-- Пояснення (відповідь у файлі answers.txt):
-- ============================================================

SELECT COUNT(*) AS total_rows_left_right
FROM order_details od
INNER JOIN orders     o   ON od.order_id   = o.id
LEFT  JOIN customers  c   ON o.customer_id = c.id
INNER JOIN products   p   ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees  e   ON o.employee_id = e.employee_id
RIGHT JOIN shippers   s   ON o.shipper_id  = s.id
INNER JOIN suppliers  sup ON p.supplier_id = sup.id;

-- ============================================================
-- Завдання 4в — employee_id > 3 та <= 10
-- ============================================================

SELECT
    od.id            AS detail_id,
    od.quantity,
    o.id             AS order_id,
    o.date           AS order_date,
    c.name           AS customer,
    p.name           AS product,
    cat.name         AS category,
    e.first_name,
    e.last_name,
    e.employee_id,
    s.name           AS shipper,
    sup.name         AS supplier
FROM order_details od
INNER JOIN orders     o   ON od.order_id   = o.id
INNER JOIN customers  c   ON o.customer_id = c.id
INNER JOIN products   p   ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees  e   ON o.employee_id = e.employee_id
INNER JOIN shippers   s   ON o.shipper_id  = s.id
INNER JOIN suppliers  sup ON p.supplier_id = sup.id
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- ============================================================
-- Завдання 4г — GROUP BY категорія, COUNT рядків, AVG quantity
-- Завдання 4д — HAVING avg_quantity > 21
-- Завдання 4е — ORDER BY count_rows DESC
-- Завдання 4є — LIMIT 4 OFFSET 1 (4 рядки, пропустити перший)
-- ============================================================

SELECT
    cat.name                    AS category_name,
    COUNT(*)                    AS count_rows,
    AVG(od.quantity)            AS avg_quantity
FROM order_details od
INNER JOIN orders     o   ON od.order_id   = o.id
INNER JOIN customers  c   ON o.customer_id = c.id
INNER JOIN products   p   ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees  e   ON o.employee_id = e.employee_id
INNER JOIN shippers   s   ON o.shipper_id  = s.id
INNER JOIN suppliers  sup ON p.supplier_id = sup.id
GROUP BY cat.name
HAVING avg_quantity > 21
ORDER BY count_rows DESC
LIMIT 4 OFFSET 1;
