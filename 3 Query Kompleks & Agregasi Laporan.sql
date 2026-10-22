SELECT p.nama,
       COUNT(s.id_sesi) AS jumlah_sesi
FROM pengguna p
JOIN sesi_login s ON s.id_pengguna  = p.id_pengguna
JOIN perangkat pr ON pr.id_perangkat = s.id_perangkat
WHERE pr.sistem_operasi = 'Linux'
GROUP BY p.id_pengguna, p.nama;
