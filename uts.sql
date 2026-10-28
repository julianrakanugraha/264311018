-- 1. MEMBUAT DATABASE
CREATE DATABASE IF NOT EXISTS nexora_ujian
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE nexora_ujian;

-- 2. RESET TABEL JIKA SUDAH ADA

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS sesi_login;
DROP TABLE IF EXISTS perangkat;
DROP TABLE IF EXISTS pengguna;

SET FOREIGN_KEY_CHECKS = 1;

-- 3. TABEL PENGGUNA

CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status_aktif TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- 4. TABEL PERANGKAT

CREATE TABLE perangkat (
    id_perangkat INT AUTO_INCREMENT PRIMARY KEY,
    nama_perangkat VARCHAR(100) NOT NULL,
    sistem_operasi ENUM('Linux', 'Windows') NOT NULL,
    status ENUM('online', 'offline', 'bermasalah')
        NOT NULL DEFAULT 'offline'
) ENGINE=InnoDB;

-- 5. TABEL SESI LOGIN

CREATE TABLE sesi_login (
    id_sesi BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna INT NOT NULL,
    id_perangkat INT NOT NULL,
    waktu_login DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    waktu_logout DATETIME NULL,

    CONSTRAINT fk_sesi_pengguna
        FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_sesi_perangkat
        FOREIGN KEY (id_perangkat)
        REFERENCES perangkat(id_perangkat)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. MEMASUKKAN DATA PENGGUNA

INSERT INTO pengguna
(nama, email, password_hash, status_aktif)
VALUES
('Julian', 'julian@example.com', 'hash_demo_julian', 1),
('Andi', 'andi@example.com', 'hash_demo_andi', 1),
('Budi', 'budi@example.com', 'hash_demo_budi', 0),
('Siti', 'siti@example.com', 'hash_demo_siti', 1),
('Raka', 'raka@example.com', 'hash_demo_raka', 1);

-- 7. MEMASUKKAN DATA PERANGKAT

INSERT INTO perangkat
(nama_perangkat, sistem_operasi, status)
VALUES
('PC Lab 01', 'Windows', 'online'),
('PC Lab 02', 'Linux', 'offline'),
('Laptop Ujian 01', 'Windows', 'online'),
('PC Lab 03', 'Linux', 'bermasalah'),
('Laptop Ujian 02', 'Windows', 'online');

-- 8. MEMASUKKAN DATA SESI LOGIN

INSERT INTO sesi_login
(id_pengguna, id_perangkat, waktu_login, waktu_logout)
VALUES
(1, 1, '2026-10-28 07:00:00', '2026-10-28 08:00:00'),
(2, 2, '2026-10-28 07:15:00', '2026-10-28 08:15:00'),
(1, 3, '2026-10-28 09:00:00', NULL),
(4, 1, '2026-10-28 09:15:00', NULL),
(5, 5, '2026-10-28 09:30:00', '2026-10-28 10:30:00');

-- 9. PENGUJIAN STRUKTUR DATABASE

SHOW TABLES;

DESCRIBE pengguna;
DESCRIBE perangkat;
DESCRIBE sesi_login;

-- 10. PENGUJIAN SELECT

SELECT * FROM pengguna;
SELECT * FROM perangkat;
SELECT * FROM sesi_login;

-- 11. PENGUJIAN JOIN ANTAR-TABEL

SELECT
    s.id_sesi,
    p.nama AS nama_pengguna,
    p.email,
    d.nama_perangkat,
    d.sistem_operasi,
    d.status AS status_perangkat,
    s.waktu_login,
    s.waktu_logout
FROM sesi_login AS s
INNER JOIN pengguna AS p
    ON s.id_pengguna = p.id_pengguna
INNER JOIN perangkat AS d
    ON s.id_perangkat = d.id_perangkat
ORDER BY s.id_sesi;

-- 12. PENGUJIAN WHERE
-- Menampilkan pengguna aktif
SELECT *
FROM pengguna
WHERE status_aktif = 1;

-- Menampilkan perangkat online
SELECT *
FROM perangkat
WHERE status = 'online';

-- Menampilkan sesi yang belum logout
SELECT *
FROM sesi_login
WHERE waktu_logout IS NULL;

-- 13. PENGUJIAN UPDATE

UPDATE pengguna
SET status_aktif = 0
WHERE id_pengguna = 2;

UPDATE perangkat
SET status = 'online'
WHERE id_perangkat = 2;

-- Memeriksa hasil UPDATE
SELECT * FROM pengguna WHERE id_pengguna = 2;
SELECT * FROM perangkat WHERE id_perangkat = 2;

-- 14. PENGUJIAN DELETE
-- Menghapus pengguna yang tidak memiliki sesi login
DELETE FROM pengguna
WHERE id_pengguna = 3;

-- Memeriksa hasil DELETE
SELECT * FROM pengguna;

-- 15. PENGUJIAN UNIQUE
-- JANGAN AKTIFKAN BERSAMA QUERY NORMAL
-- QUERY INI SEHARUSNYA GAGAL KARENA EMAIL DUPLIKAT

-- INSERT INTO pengguna
-- (nama, email, password_hash)
-- VALUES ('Pengguna Duplikat',
--         'julian@example.com', 'hash_tes');

-- 16. PENGUJIAN FOREIGN KEY
-- QUERY BERIKUT SEHARUSNYA GAGAL

-- INSERT INTO sesi_login
-- (id_pengguna, id_perangkat, waktu_login)
-- VALUES (99999, 1, NOW());

-- INSERT INTO sesi_login
-- (id_pengguna, id_perangkat, waktu_login)
-- VALUES (1, 99999, NOW());

-- 17. PENGUJIAN ON DELETE RESTRICT
-- QUERY BERIKUT SEHARUSNYA GAGAL JIKA DATA DIRELASIKAN

-- DELETE FROM pengguna WHERE id_pengguna = 1;
-- DELETE FROM perangkat WHERE id_perangkat = 1;

-- 18. PENGUJIAN JUMLAH DATA

SELECT COUNT(*) AS total_pengguna
FROM pengguna;

SELECT COUNT(*) AS total_perangkat
FROM perangkat;

SELECT COUNT(*) AS total_sesi_login
FROM sesi_login;

-- 19. LAPORAN SESI LOGIN AKTIF

SELECT
    s.id_sesi,
    p.nama AS nama_pengguna,
    d.nama_perangkat,
    s.waktu_login,
    s.waktu_logout
FROM sesi_login AS s
INNER JOIN pengguna AS p
    ON s.id_pengguna = p.id_pengguna
INNER JOIN perangkat AS d
    ON s.id_perangkat = d.id_perangkat
WHERE s.waktu_logout IS NULL;

-- 20. PEMERIKSAAN AKHIR

SELECT 'PENGGUNA' AS nama_tabel, COUNT(*) AS jumlah
FROM pengguna

UNION ALL

SELECT 'PERANGKAT', COUNT(*)
FROM perangkat

UNION ALL

SELECT 'SESI_LOGIN', COUNT(*)
FROM sesi_login;
