INSERT INTO pengguna (nama, email, password_hash, status_aktif) VALUES
 ('Peter Parker',  'peter123@nexora.test', 'placeholder_hash_01', 1),
 ('Tony Stark', 'tonytony@nexora.test', 'placeholder_hash_02', 1),
 ('joker',    'joker.guru@nexora.test', 'placeholder_hash_03', 1);

INSERT INTO perangkat (nama_perangkat, sistem_operasi, status) VALUES
 ('DKV-01', 'Windows', 'online'),
 ('DKV-03', 'Windows',   'online'),
 ('RPL-01', 'Linux',   'online');

INSERT INTO sesi_login (id_pengguna, id_perangkat, waktu_login, waktu_logout) VALUES
 (1, 1, '2026-10-15 08:00:00', '2026-10-15 09:30:00'),
 (2, 3, '2026-10-15 09:15:00', NULL),
 (3, 2, '2026-10-15 10:00:00', NULL);
