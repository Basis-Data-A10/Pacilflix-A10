-- Kelas : Basis Data A
-- Nomor Kelompok : 10
-- Anggota Kelompok : 1. Muhammad Yusuf Haikal (2206081490)
-- 2. Arju Naja Muhammad (2206082045)
-- 3. Novrizal Airsyahputra (2206081780)
-- 4. Rana Koesumastuti (2206083496)


CREATE TABLE PENGGUNA(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    id_tayangan UUID,
    negara_asal VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PAKET(
    nama VARCHAR(50) PRIMARY KEY,
    harga INT NOT NULL CHECK (harga >= 0),
    resolusi_layar VARCHAR(50) NOT NULL
);

CREATE TABLE DUKUNGAN_PERANGKAT(
    nama_paket VARCHAR(50),
    dukungan_perangkat VARCHAR(50),
    PRIMARY KEY (nama_paket, dukungan_perangkat), 
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TRANSACTION(
    username VARCHAR(50),
    start_date_time DATE,
    end_date_time DATE,
    nama_paket VARCHAR(50),
    metode_pembayaran VARCHAR(50) NOT NULL,
    timestamp_pembayaran TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time), 
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nama_paket) REFERENCES PAKET(nama) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE CONTRIBUTORS(
    id UUID PRIMARY KEY, 
    nama VARCHAR(50) NOT NULL,
    jenis_kelamin INT NOT NULL CHECK (jenis_kelamin IN (0, 1)),
    kewarganegaraan VARCHAR(50) NOT NULL
);

CREATE TABLE PENULIS_SKENARIO(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PEMAIN(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE SUTRADARA(
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TAYANGAN(
    id UUID PRIMARY KEY,
    judul VARCHAR(100) NOT NULL,
    sinopsis VARCHAR(255) NOT NULL,
    asal_negara VARCHAR(50) NOT NULL,
    sinopsis_trailer VARCHAR(255) NOT NULL,
    url_video_trailer VARCHAR(255) NOT NULL,
    release_date_trailer DATE NOT NULL,
    id_sutradara UUID,
    FOREIGN KEY (id_sutradara) REFERENCES SUTRADARA(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE MEMAINKAN_TAYANGAN(
    id_tayangan UUID,
    id_pemain UUID,
    PRIMARY KEY (id_tayangan, id_pemain),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_pemain) REFERENCES PEMAIN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE MENULIS_SKENARIO_TAYANGAN(
    id_tayangan UUID,
    id_penulis_skenario UUID,
    PRIMARY KEY (id_tayangan, id_penulis_skenario),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_penulis_skenario) REFERENCES PENULIS_SKENARIO(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE GENRE_TAYANGAN(
    id_tayangan UUID,
    genre VARCHAR(50),
    PRIMARY KEY (id_tayangan, genre),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PERUSAHAAN_PRODUKSI(
    nama VARCHAR(100) PRIMARY KEY
);

CREATE TABLE PERSETUJUAN(
    nama VARCHAR(100),
    id_tayangan UUID,
    tanggal_persetujuan DATE,
    durasi INT NOT NULL CHECK (durasi >= 0),
    biaya INT NOT NULL CHECK (biaya >= 0),
    tanggal_mulai_penayangan DATE NOT NULL,
    PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan),
    FOREIGN KEY (nama) REFERENCES PERUSAHAAN_PRODUKSI(nama) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE SERIES(
    id_tayangan UUID PRIMARY KEY,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)
);

CREATE TABLE FILM(
    id_tayangan UUID PRIMARY KEY,
    url_video_film VARCHAR(255) NOT NULL,
    release_date_film DATE NOT NULL,
    durasi_film INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE EPISODE(
    id_series UUID,
    sub_judul VARCHAR(100),
    sinopsis VARCHAR (255) NOT NULL,
    durasi INT NOT NULL DEFAULT 0,
    url_video VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    PRIMARY KEY (id_series, sub_judul),
    FOREIGN KEY (id_series) REFERENCES SERIES(id_tayangan) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ULASAN(
    id_tayangan UUID,
    username VARCHAR(50),
    timestamp TIMESTAMP,
    rating INT NOT NULL DEFAULT 0,
    deskripsi VARCHAR(255),
    PRIMARY KEY (username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TAYANGAN_MEMILIKI_DAFTAR_FAVORIT(
    id_tayangan UUID,
    timestamp TIMESTAMP, 
    username VARCHAR(50),
    PRIMARY KEY (id_tayangan, timestamp, username),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username, timestamp) REFERENCES DAFTAR_FAVORIT(username, timestamp) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DAFTAR_FAVORIT(
    timestamp TIMESTAMP,
    username VARCHAR(50),
    judul VARCHAR(50) NOT NULL,
    PRIMARY KEY (timestamp, username),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE RIWAYAT_NONTON(
    id_tayangan UUID,
    username VARCHAR(50),
    start_date_time TIMESTAMP,
    end_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TAYANGAN_TERUNDUH(
    id_tayangan UUID,
    username VARCHAR(50), 
    timestamp TIMESTAMP,
    PRIMARY KEY (id_tayangan, username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES PENGGUNA(username) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO PAKET VALUES ('Basic',50000.0,'720p'),
	('Premium',100000.0,'1080p'),
	('Ultra',150000.0,'1440p');

INSERT INTO DUKUNGAN_PERANGKAT VALUES ('Basic','Smartphone'),
	('Basic','Tablet'),
	('Premium','Smartphone'),
	('Premium','Tablet'),
	('Premium','Smart TV'),
	('Premium','Laptop'),
	('Ultra','Smartphone'),
	('Ultra','Tablet'),
	('Ultra','Smart TV'),
	('Ultra','Laptop'),
	('Ultra','Desktop');


INSERT INTO PERUSAHAAN_PRODUKSI VALUES ('Paramount'),
	('Warner Bros'),
	('A24'),
	('Lionsgate'),
	('Walt Disney Company'),
	('Universal Pictures'),
	('MGM'),
	('Pixar Animation Studios'),
	('20th Century Studios'),
	('Legendary Pictures Productions'),
	('DreamWorks Animation'),
	('Sony Pictures'),
	('Falcon Pictures'),
	('Miles Film'),
	('MD Pictures');

INSERT INTO CONTRIBUTORS VALUES ('ddb026ab-b2c2-44fe-b725-545e41e6ab57','Timothee Chalamet',0.0,'Prancis'),
	('07641635-cb2c-44f9-be89-80065b0a29f9','Steven Spielberg',0.0,'Amerika Serikat'),
	('4947cbb4-08e0-4a36-a4f1-7914447fd7f4','Martin Scorsese',0.0,'Amerika Serikat'),
	('e63dbbf1-b4a7-4a7f-968d-dc2113d8b89d','Ridley Scott',0.0,'Britania Raya'),
	('c4998b95-a470-40c6-a232-b9538d7e677f','Christopher Nolan',0.0,'Britania Raya'),
	('d26d9f16-b923-47fd-9d5b-2e742c9c00ca','Tim Burton',0.0,'Amerika Serikat'),
	('3e8794cb-d71d-47b8-b23d-8ce9295818cb','Hayao Miyazaki',0.0,'Jepang'),
	('8697c204-abfe-4eb9-ba91-9f48be3bb178','Sofia Coppola',1.0,'Amerika Serikat'),
	('55340e58-efc3-414d-acdb-fc99603f00e8','Quentin Tarantino',0.0,'Amerika Serikat'),
	('a848ad23-6260-48c6-9900-097786ccd93f','James Cameron',0.0,'Kanada'),
	('ad68eefe-64bd-4a37-aa15-5152c5980241','Lana Wachowski',1.0,'Amerika Serikat'),
	('e42ab6ad-310a-472e-b0de-4f5088b2ac5a','Nora Ephron',1.0,'Amerika Serikat'),
	('addafc4c-f63f-4f41-99dc-a4e5d7279daa','Woody Allen',0.0,'Amerika Serikat'),
	('180deaa0-0735-40eb-bbd9-6689bae47647','Jordan Poole',0.0,'Amerika Serikat'),
	('9f74f60f-6b81-42a2-a9f9-b5f71e18a1f9','Spike Lee',0.0,'Amerika Serikat'),
	('747aa339-ae36-4679-b649-64b916700897','Greta Gerwig',1.0,'Amerika Serikat'),
	('239e4745-abb1-47ec-8457-5f9401d52451','Amy Heckerling',1.0,'Amerika Serikat'),
	('edc2e71e-a4f0-46fd-be9a-b04f2c57aa51','John Woo',0.0,'Cina'),
	('6076a415-b0a4-4975-a500-5979d225d6e2','Peter Jackson',0.0,'Selandia Baru'),
	('d99314ac-a4ed-4116-b404-88c88eeec608','Clint Easwood',0.0,'Amerika Serikat'),
	('66218fe9-31ff-4ec6-bca3-f37ee8368325','David Fincher',0.0,'Amerika Serikat'),
	('e382c8a9-f5c5-4b20-a93a-845a463fabeb','Francis Ford Coppola',0.0,'Amerika Serikat'),
	('58168e19-c1e7-4782-a1fa-73b9782c29e3','Brian De Palma',0.0,'Amerika Serikat'),
	('fee9fd09-9557-4373-b7f5-fa59a2b84272','Robert Zemeckis',0.0,'Amerika Serikat'),
	('af328a01-c208-4490-98c8-9b38d430c20c','Lily Wachowski',1.0,'Amerika Serikat'),
	('bbaf2dfd-bb85-4ae5-bc71-d6edea05d36b','Guillermo del Toro',0.0,'Meksiko'),
	('ba49869e-52b8-4e5f-a855-9c82903e101b','Guy Ritchie',0.0,'Britania Raya'),
	('455094ef-19de-4157-972c-9809f55b011f','Oliver Stone',0.0,'Amerika Serikat'),
	('c5041569-e152-4916-98fb-78d5933ca416','Stanley Kubrick',0.0,'Amerika Serikat'),
	('020241a8-46cc-44c2-b0b7-73337f34a180','Yimou Zhang',0.0,'Cina'),
	('1907f090-77d9-44f2-a986-73ba1ea08c1f','Lee Unkrich',0.0,'Amerika Serikat'),
	('c67b4d2c-be43-4a9d-99af-09a758a61a39','Akira Kurosawa',0.0,'Jepang'),
	('abf1e4d5-b7c2-44a2-87ae-054a6ab56741','Joko Anwar',0.0,'Indonesia'),
	('4678d81a-18be-4d78-879e-ff0026769717','Mira Lesmana',1.0,'Indonesia'),
	('1dc778e6-e273-4f25-8150-e4c5fd7808e0','Riri Riza',0.0,'Indonesia'),
	('e82c47a4-7ddf-441d-ae75-0cb783b89ac8','Garin Nugroho',0.0,'Indonesia'),
	('81e1fb0f-4ce3-4e61-9f35-e1d51fdfb008','George Lucas',0.0,'Amerikat Serikat'),
	('427f20a4-f807-4e82-b83d-5ff0cbf440e5','Paul Thomas Anderson',0.0,'Amerika Serikat'),
	('89d61cc7-d3f3-4f19-9962-b97636fabd00','Prachya Pinkaew',0.0,'Thailand'),
	('e273e7eb-3857-464e-88a8-fcef6155747f','Jon Favreau',0.0,'Amerika Serikat'),
	('4830c774-a07a-4e34-9fb4-aba239cd5507','Meryl Streep',1.0,'Amerika Serikat'),
	('f07c2a65-1d73-4e30-94a4-3582ddef78e2','Denzel Washington',0.0,'Amerika Serikat'),
	('c532e35c-f2d5-4522-8d3e-f58be921510b','Cate Blanchett',1.0,'Australia'),
	('f2f5ec43-02d7-4889-bec2-286a8723b500','Johnny Depp',0.0,'Amerika Serikat'),
	('6780c512-76a4-4d7f-a1b9-4a4e8c57d4a5','Judi Dench',1.0,'Britania Raya'),
	('b2d562d8-38cb-46a8-b685-6f5d65b7c099','Ian McKellen',0.0,'Britania Raya'),
	('d32deff3-ad36-4493-b75c-7c4b9a03cd82','Natalie Portman',1.0,'Amerika Serikat'),
	('8329777c-a1ec-4bc1-b764-ea380180251c','Leonardo DiCaprio',0.0,'Amerika Serikat'),
	('a8f960b9-35a7-43c0-b17e-74cc104c2491','Robert Downey Jr',0.0,'Amerika Serikat'),
	('d2c328dc-3f87-4783-9829-79bbf46dbf21','Brad Pitt',0.0,'Amerika Serikat'),
	('929e5911-061b-4747-8364-f27cc9e3a31c','Jodie Foster',1.0,'Amerika Serikat'),
	('97f89ff1-8789-4a22-bfda-1f961286821b','Anne Hathaway',1.0,'Amerika Serikat'),
	('50dd0a09-fb16-4568-8235-ef9baffe1740','Liam Neeson',0.0,'Britania Raya'),
	('30e609ee-35a6-470c-88ef-a43d26172f06','Hugh Jackman',0.0,'Australia'),
	('02d6aa4a-d689-4fe9-974b-41d88357d73b','Morgan Freeman',0.0,'Amerika Serikat'),
	('a0f40dfa-dfbf-4190-b5f1-8b69d01a8e0f','Charlize Theron',1.0,'Afrika Selatan'),
	('f46be13a-698b-48b5-8831-ec04ffe68bd4','Kate Winslet',1.0,'Britania Raya'),
	('e1745c69-ad15-4fef-aa54-13ac8cf1bf72','Philip Seymour Hoffman',0.0,'Amerika Serikat'),
	('a1bc2b3c-9c7d-4445-a20c-defc18b73192','Marion Cotillard',1.0,'Prancis'),
	('9bcb0ad3-801d-49ca-9ac8-a2542a81e028','Amy Adams',1.0,'Amerika Serikat'),
	('65fcf778-1ad4-4407-bc01-e3fd22fcc9e6','Nicole Kidman',1.0,'Australia'),
	('889644f1-fac8-40e9-bc7d-2b13dad9e9b7','Christian Bale',0.0,'Britania Raya'),
	('362aa5bd-5a2e-4506-97e4-e1956c10f35a','Joaquin Phoenix',1.0,'Amerika Serikat'),
	('aa8ef611-1158-4d9e-950f-d3ecccd40c4f','Viola Davis',0.0,'Amerika Serikat'),
	('88cabaf2-11d7-4ef2-8135-f5b4a5958162','Matt Damon',0.0,'Amerika Serikat'),
	('007bc7c4-ac1d-4a84-be25-2e3ad6bda625','Rooney Mara',1.0,'Amerika Serikat'),
	('320ecb8f-254b-41a7-abb0-debcc66a3b95','Jennifer Lawrence',1.0,'Amerika Serikat'),
	('c8580384-ffe5-49dd-9d2b-5e64aa044bac','Zoe Saldana',1.0,'Amerika Serikat'),
	('83b40194-8680-4e92-8d32-38080966ae0e','Rachel McAdams',1.0,'Kanada'),
	('2a6eb37d-14ed-4970-93df-28d32f0df0cf','George Clooney',0.0,'America Serikat'),
	('7af31ec1-fc7b-4e5c-ae79-81b63070c33f','Dustin Hoffman',0.0,'Amerika Serikat'),
	('8971775f-8b9a-4061-af3e-517a035f5552','Will Smith',0.0,'Amerika Serikat'),
	('b15ec03c-db2d-437d-a5f2-25ad0e1c129f','Daniel Craig',0.0,'Britania Raya'),
	('6f962713-b1d1-4e6c-b493-ebeb02d4fd59','Benedict Cumberbatch',0.0,'Britania Raya'),
	('3c644270-4b4c-4af8-b7d4-1409bd34efd0','Gerard Butler',0.0,'Skotlandia'),
	('7b6d8b4e-245e-4c12-be5c-7bff24c9751e','Kevin Spacey',0.0,'Amerika Serikat'),
	('d50adad7-7657-4dce-b3d9-89e957f55aab','Russell Crowe',0.0,'Selandia Baru'),
	('6210be5a-988a-42a8-ba74-f52d00593115','Cilian Murphy',0.0,'Irlandia'),
	('3abb7796-8c29-4f4b-abc8-f83ac4d2617c','Emma Stone',1.0,'Amerika Serikat'),
	('9d63e6d8-4d8f-41e2-aa9c-ef90ddd6052d','Reese Witherspoon',1.0,'Amerika Serikat');

INSERT INTO PEMAIN VALUES ('4830c774-a07a-4e34-9fb4-aba239cd5507'),
	('f07c2a65-1d73-4e30-94a4-3582ddef78e2'),
	('c532e35c-f2d5-4522-8d3e-f58be921510b'),
	('f2f5ec43-02d7-4889-bec2-286a8723b500'),
	('6780c512-76a4-4d7f-a1b9-4a4e8c57d4a5'),
	('b2d562d8-38cb-46a8-b685-6f5d65b7c099'),
	('d32deff3-ad36-4493-b75c-7c4b9a03cd82'),
	('8329777c-a1ec-4bc1-b764-ea380180251c'),
	('a8f960b9-35a7-43c0-b17e-74cc104c2491'),
	('d2c328dc-3f87-4783-9829-79bbf46dbf21'),
	('929e5911-061b-4747-8364-f27cc9e3a31c'),
	('97f89ff1-8789-4a22-bfda-1f961286821b'),
	('50dd0a09-fb16-4568-8235-ef9baffe1740'),
	('30e609ee-35a6-470c-88ef-a43d26172f06'),
	('02d6aa4a-d689-4fe9-974b-41d88357d73b'),
	('a0f40dfa-dfbf-4190-b5f1-8b69d01a8e0f'),
	('f46be13a-698b-48b5-8831-ec04ffe68bd4'),
	('e1745c69-ad15-4fef-aa54-13ac8cf1bf72'),
	('a1bc2b3c-9c7d-4445-a20c-defc18b73192'),
	('9bcb0ad3-801d-49ca-9ac8-a2542a81e028'),
	('65fcf778-1ad4-4407-bc01-e3fd22fcc9e6'),
	('889644f1-fac8-40e9-bc7d-2b13dad9e9b7'),
	('362aa5bd-5a2e-4506-97e4-e1956c10f35a'),
	('aa8ef611-1158-4d9e-950f-d3ecccd40c4f'),
	('88cabaf2-11d7-4ef2-8135-f5b4a5958162'),
	('007bc7c4-ac1d-4a84-be25-2e3ad6bda625'),
	('320ecb8f-254b-41a7-abb0-debcc66a3b95'),
	('c8580384-ffe5-49dd-9d2b-5e64aa044bac'),
	('83b40194-8680-4e92-8d32-38080966ae0e'),
	('2a6eb37d-14ed-4970-93df-28d32f0df0cf'),
	('7af31ec1-fc7b-4e5c-ae79-81b63070c33f'),
	('8971775f-8b9a-4061-af3e-517a035f5552'),
	('b15ec03c-db2d-437d-a5f2-25ad0e1c129f'),
	('6f962713-b1d1-4e6c-b493-ebeb02d4fd59'),
	('3c644270-4b4c-4af8-b7d4-1409bd34efd0'),
	('7b6d8b4e-245e-4c12-be5c-7bff24c9751e'),
	('d50adad7-7657-4dce-b3d9-89e957f55aab'),
	('6210be5a-988a-42a8-ba74-f52d00593115'),
	('3abb7796-8c29-4f4b-abc8-f83ac4d2617c'),
	('9d63e6d8-4d8f-41e2-aa9c-ef90ddd6052d');

INSERT INTO PENULIS_SKENARIO VALUES ('ddb026ab-b2c2-44fe-b725-545e41e6ab57'),
	('07641635-cb2c-44f9-be89-80065b0a29f9'),
	('4947cbb4-08e0-4a36-a4f1-7914447fd7f4'),
	('e63dbbf1-b4a7-4a7f-968d-dc2113d8b89d'),
	('c4998b95-a470-40c6-a232-b9538d7e677f'),
	('d26d9f16-b923-47fd-9d5b-2e742c9c00ca'),
	('3e8794cb-d71d-47b8-b23d-8ce9295818cb'),
	('8697c204-abfe-4eb9-ba91-9f48be3bb178'),
	('55340e58-efc3-414d-acdb-fc99603f00e8'),
	('a848ad23-6260-48c6-9900-097786ccd93f'),
	('ad68eefe-64bd-4a37-aa15-5152c5980241'),
	('e42ab6ad-310a-472e-b0de-4f5088b2ac5a'),
	('addafc4c-f63f-4f41-99dc-a4e5d7279daa'),
	('180deaa0-0735-40eb-bbd9-6689bae47647'),
	('9f74f60f-6b81-42a2-a9f9-b5f71e18a1f9'),
	('747aa339-ae36-4679-b649-64b916700897'),
	('239e4745-abb1-47ec-8457-5f9401d52451'),
	('edc2e71e-a4f0-46fd-be9a-b04f2c57aa51'),
	('6076a415-b0a4-4975-a500-5979d225d6e2'),
	('d99314ac-a4ed-4116-b404-88c88eeec608'),
	('66218fe9-31ff-4ec6-bca3-f37ee8368325'),
	('e382c8a9-f5c5-4b20-a93a-845a463fabeb'),
	('58168e19-c1e7-4782-a1fa-73b9782c29e3'),
	('fee9fd09-9557-4373-b7f5-fa59a2b84272'),
	('af328a01-c208-4490-98c8-9b38d430c20c'),
	('bbaf2dfd-bb85-4ae5-bc71-d6edea05d36b'),
	('ba49869e-52b8-4e5f-a855-9c82903e101b'),
	('455094ef-19de-4157-972c-9809f55b011f'),
	('c5041569-e152-4916-98fb-78d5933ca416'),
	('020241a8-46cc-44c2-b0b7-73337f34a180');

INSERT INTO SUTRADARA VALUES ('1907f090-77d9-44f2-a986-73ba1ea08c1f'),
	('c67b4d2c-be43-4a9d-99af-09a758a61a39'),
	('abf1e4d5-b7c2-44a2-87ae-054a6ab56741'),
	('4678d81a-18be-4d78-879e-ff0026769717'),
	('1dc778e6-e273-4f25-8150-e4c5fd7808e0'),
	('e82c47a4-7ddf-441d-ae75-0cb783b89ac8'),
	('81e1fb0f-4ce3-4e61-9f35-e1d51fdfb008'),
	('427f20a4-f807-4e82-b83d-5ff0cbf440e5'),
	('89d61cc7-d3f3-4f19-9962-b97636fabd00'),
	('e273e7eb-3857-464e-88a8-fcef6155747f');

INSERT INTO TAYANGAN VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','Game of Thrones','Serial epik fantasi yang mengikuti pertarungan untuk Takhta Besi Besi di tujuh kerajaan Westeros','Amerika Serikat','Trailer menampilkan adegan-adegan epik dari pertempuran dan intrik di Westeros','https://www.youtube.com/watch?v=KPLWWIOCOOQ','2010-12-01 00:00:00','1907f090-77d9-44f2-a986-73ba1ea08c1f'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','Titanic','Film drama romantis tentang kisah cinta tragis di kapal Titanic yang tenggelam','Amerika Serikat','Trailer menampilkan adegan-adegan ikonik seperti Rose dan Jack di buritan kapal','https://www.youtube.com/watch?v=CHekzSiZjrY','1997-11-01 00:00:00','c67b4d2c-be43-4a9d-99af-09a758a61a39'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','Friends','Serial komedi situasi tentang kehidupan enam sahabat di New York City','Amerika Serikat','Trailer menampilkan adegan-adegan lucu dan ikonik dari serial ini','https://www.youtube.com/watch?v=LTpmw0Ac6Zs','1994-09-22 00:00:00','abf1e4d5-b7c2-44a2-87ae-054a6ab56741'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','The Conjuring','Film horor supranatural berdasarkan kasus nyata dari pasangan paranormal Ed dan Lorraine Warren','Amerika Serikat','Trailer menampilkan adegan-adegan menakutkan dan mencekam dari film ini','https://www.youtube.com/watch?v=ejMMn0t58Lc','2013-03-20 00:00:00','4678d81a-18be-4d78-879e-ff0026769717'),
	('bdec427b-619d-4519-bccc-12c402716dc8','Descendants of the Sun','Serial drama keluarga tentang pasangan militer dan dokter di zona konflik','Korea Selatan','Trailer menampilkan adegan-adegan romantis dan aksi dari serial ini','https://www.youtube.com/watch?v=wTGwjDqtfzQ','2016-02-24 00:00:00','1dc778e6-e273-4f25-8150-e4c5fd7808e0'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','John Wick','Film aksi laga tentang pembunuh bayaran yang mencari balas dendam','Amerika Serikat','Trailer menampilkan adegan-adegan aksi laga yang mengagumkan dari film ini','https://www.youtube.com/watch?v=C0BMx-qxsP4','2014-10-24 00:00:00','e82c47a4-7ddf-441d-ae75-0cb783b89ac8'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','Forrest Gump','Film drama komedi tentang seorang pria sederhana yang terlibat dalam beberapa peristiwa bersejarah.'', ''Amerika Serikat'', ''Trailer menampilkan adegan-adegan ikonik dari film ini.','Amerika Serikat','Trailer menampilkan adegan-adegan ikonik dari film ini.','https://www.youtube.com/watch?v=bLvqoHBptjg','1994-06-23 00:00:00','81e1fb0f-4ce3-4e61-9f35-e1d51fdfb008'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','Planet Earth II','Film dokumenter alam liar yang menampilkan pemandangan menakjubkan dari seluruh dunia','Britania Raya','Trailer menampilkan cuplikan-cuplikan adegan menakjubkan dari film ini','https://www.youtube.com/watch?v=92bmDq2h92Q','2016-11-06 00:00:00','427f20a4-f807-4e82-b83d-5ff0cbf440e5'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','Sherlock','Serial misteri kriminal modern yang mengadaptasi kisah Sherlock Holmes','Britania Raya','Trailer menampilkan adegan-adegan misteri dan petualangan dari serial ini.','https://www.youtube.com/watch?v=gGqWqGOSTGQ','2010-07-25 00:00:00','89d61cc7-d3f3-4f19-9962-b97636fabd00'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','Toy Story','Film animasi petualangan tentang mainan yang hidup.','Amerika Serikat','Trailer menampilkan adegan-adegan lucu dan mengharukan dari film ini.','https://www.youtube.com/watch?v=v-PjgYDrg70','1995-11-22 00:00:00','e273e7eb-3857-464e-88a8-fcef6155747f'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','Hospital Playlist','Serial drama medis tentang kehidupan sekelompok dokter dan persahabatan mereka','Korea Selatan','Trailer menampilkan adegan-adegan emosional dan komedi dari serial ini.','https://www.youtube.com/watch?v=bc8TCfhwAy8','2020-03-12 00:00:00','abf1e4d5-b7c2-44a2-87ae-054a6ab56741'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','The Social Network','Film biografi tentang pendiri Facebook, Mark Zuckerberg.','Amerika Serikat','Trailer menampilkan adegan-adegan dari awal pembentukan Facebook','https://www.youtube.com/watch?v=lB95KLmpLR4','2010-09-24 00:00:00','4678d81a-18be-4d78-879e-ff0026769717'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','The Lord of the Rings','Film fantasi epik berdasarkan novel-novel J.R.R. Tolkien.','Amerika Serikat','Trailer menampilkan adegan-adegan epik dari pertempuran dan petualangan di Middle-earth','https://www.youtube.com/watch?v=V75dMMIW2B4','2001-12-19 00:00:00','1dc778e6-e273-4f25-8150-e4c5fd7808e0'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','La La Land','Film musikal romantis tentang seorang aktor dan musisi yang jatuh cinta.','Amerika Serikat','Trailer menampilkan adegan-adegan menari dan menyanyi dari film ini','https://www.youtube.com/watch?v=0pdqf4P9MB8','2016-08-31 00:00:00','e82c47a4-7ddf-441d-ae75-0cb783b89ac8'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','Inception','Film sci-fi tentang pencurian ide melalui mimpi.','Amerika Serikat','Trailer menampilkan adegan-adegan aksi dan efek visual yang menakjubkan.','https://www.youtube.com/watch?v=YoHD9XEInc0','2010-07-16 00:00:00','81e1fb0f-4ce3-4e61-9f35-e1d51fdfb008');

INSERT INTO SERIES VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc'),
	('bdec427b-619d-4519-bccc-12c402716dc8'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6');

INSERT INTO EPISODE VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','Winter Is Coming','Sinopsis episode pertama Game of Thrones',60.0,'https://example.com/got_episode1.mp4','2011-04-17 00:00:00'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','The Kingsroad','Sinopsis episode kedua Game of Thrones',55.0,'https://example.com/got_episode2.mp4','2011-04-24 00:00:00'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','The One Where Monica Gets a Roommate','Sinopsis episode pertama Friends',22.0,'https://example.com/friends_episode1.mp4','1994-09-22 00:00:00'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','The One With The Sonogram at The End','Sinopsis episode kedua Friends',22.0,'https://example.com/friends_episode2.mp4','1994-09-29 00:00:00'),
	('bdec427b-619d-4519-bccc-12c402716dc8','DOTS E1S1','Sinopsis episode pertama Descendants of the Sun',65.0,'https://example.com/descendants_episode1.mp4','2016-02-24 00:00:00'),
	('bdec427b-619d-4519-bccc-12c402716dc8','DOTS E2S1','Sinopsis episode kedua Descendants of the Sun',65.0,'https://example.com/descendants_episode2.mp4','2016-03-02 00:00:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','A Study in Pink','Sinopsis episode pertama Sherlock',90.0,'https://example.com/sherlock_episode1.mp4','2010-07-25 00:00:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','The Blind Banker','Sinopsis episode kedua Sherlock',90.0,'https://example.com/sherlock_episode2.mp4','2010-08-01 00:00:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','HP E1S1','Sinopsis episode pertama Hospital Playlist',90.0,'https://example.com/hospitalplaylist_episode1.mp4','2020-03-12 00:00:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','HP E2S1','Sinopsis episode kedua Hospital Playlist',90.0,'https://example.com/hospitalplaylist_episode2.mp4','2020-03-19 00:00:00'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','Lord Snow','Sinopsis episode ketiga Game of Thrones',60.0,'https://example.com/got_episode3.mp4','2011-05-01 00:00:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','The Great Game','Sinopsis episode ketiga Sherlock',90.0,'https://example.com/sherlock_episode3.mp4','2010-08-08 00:00:00');

INSERT INTO FILM VALUES ('e543fa4c-4b12-4c70-bba2-56e7971c28b0','https://example.com/titanic_film.mp4','1997-12-19 00:00:00',194.0),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','https://example.com/theconjuring_film.mp4','2013-07-19 00:00:00',112.0),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','https://example.com/johnwick_film.mp4','2014-10-24 00:00:00',101.0),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','https://example.com/forrestgump_film.mp4','1994-07-06 00:00:00',142.0),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','https://example.com/planetearthii_film.mp4','2016-11-06 00:00:00',360.0),
	('05489cf3-aaa4-4513-8445-ece734a7a588','https://example.com/toystory_film.mp4','1995-11-22 00:00:00',81.0),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','https://example.com/thesocialnetwork_film.mp4','2010-10-01 00:00:00',120.0),
	('eb4625d9-e65c-4750-89b3-8366481ad098','https://example.com/thelordoftherings_film.mp4','2001-12-19 00:00:00',201.0),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','https://example.com/lalaland_film.mp4','2016-12-09 00:00:00',128.0),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','https://example.com/inception_film.mp4','2010-07-16 00:00:00',148.0);

INSERT INTO MEMAINKAN_TAYANGAN VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','4830c774-a07a-4e34-9fb4-aba239cd5507'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','f07c2a65-1d73-4e30-94a4-3582ddef78e2'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','c532e35c-f2d5-4522-8d3e-f58be921510b'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','f2f5ec43-02d7-4889-bec2-286a8723b500'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','6780c512-76a4-4d7f-a1b9-4a4e8c57d4a5'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','b2d562d8-38cb-46a8-b685-6f5d65b7c099'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','d32deff3-ad36-4493-b75c-7c4b9a03cd82'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','8329777c-a1ec-4bc1-b764-ea380180251c'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','a8f960b9-35a7-43c0-b17e-74cc104c2491'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','d2c328dc-3f87-4783-9829-79bbf46dbf21'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','929e5911-061b-4747-8364-f27cc9e3a31c'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','97f89ff1-8789-4a22-bfda-1f961286821b'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','50dd0a09-fb16-4568-8235-ef9baffe1740'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','30e609ee-35a6-470c-88ef-a43d26172f06'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','02d6aa4a-d689-4fe9-974b-41d88357d73b'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','a0f40dfa-dfbf-4190-b5f1-8b69d01a8e0f'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','f46be13a-698b-48b5-8831-ec04ffe68bd4'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','e1745c69-ad15-4fef-aa54-13ac8cf1bf72'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','a1bc2b3c-9c7d-4445-a20c-defc18b73192'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','9bcb0ad3-801d-49ca-9ac8-a2542a81e028'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','65fcf778-1ad4-4407-bc01-e3fd22fcc9e6'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','889644f1-fac8-40e9-bc7d-2b13dad9e9b7'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','362aa5bd-5a2e-4506-97e4-e1956c10f35a'),
	('bdec427b-619d-4519-bccc-12c402716dc8','aa8ef611-1158-4d9e-950f-d3ecccd40c4f'),
	('bdec427b-619d-4519-bccc-12c402716dc8','88cabaf2-11d7-4ef2-8135-f5b4a5958162'),
	('bdec427b-619d-4519-bccc-12c402716dc8','007bc7c4-ac1d-4a84-be25-2e3ad6bda625'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','320ecb8f-254b-41a7-abb0-debcc66a3b95'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','c8580384-ffe5-49dd-9d2b-5e64aa044bac'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','83b40194-8680-4e92-8d32-38080966ae0e'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','2a6eb37d-14ed-4970-93df-28d32f0df0cf'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','7af31ec1-fc7b-4e5c-ae79-81b63070c33f'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','8971775f-8b9a-4061-af3e-517a035f5552'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','b15ec03c-db2d-437d-a5f2-25ad0e1c129f'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','6f962713-b1d1-4e6c-b493-ebeb02d4fd59'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','3c644270-4b4c-4af8-b7d4-1409bd34efd0'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','7b6d8b4e-245e-4c12-be5c-7bff24c9751e'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','d50adad7-7657-4dce-b3d9-89e957f55aab'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','6210be5a-988a-42a8-ba74-f52d00593115'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','3abb7796-8c29-4f4b-abc8-f83ac4d2617c'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','9d63e6d8-4d8f-41e2-aa9c-ef90ddd6052d'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','4830c774-a07a-4e34-9fb4-aba239cd5507'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','f07c2a65-1d73-4e30-94a4-3582ddef78e2'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','c532e35c-f2d5-4522-8d3e-f58be921510b'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','f2f5ec43-02d7-4889-bec2-286a8723b500'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','6780c512-76a4-4d7f-a1b9-4a4e8c57d4a5'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','b2d562d8-38cb-46a8-b685-6f5d65b7c099'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','d32deff3-ad36-4493-b75c-7c4b9a03cd82'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','8329777c-a1ec-4bc1-b764-ea380180251c'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','a8f960b9-35a7-43c0-b17e-74cc104c2491'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','d2c328dc-3f87-4783-9829-79bbf46dbf21');

INSERT INTO MENULIS_SKENARIO_TAYANGAN VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','ddb026ab-b2c2-44fe-b725-545e41e6ab57'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','07641635-cb2c-44f9-be89-80065b0a29f9'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','4947cbb4-08e0-4a36-a4f1-7914447fd7f4'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','e63dbbf1-b4a7-4a7f-968d-dc2113d8b89d'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','c4998b95-a470-40c6-a232-b9538d7e677f'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','d26d9f16-b923-47fd-9d5b-2e742c9c00ca'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','3e8794cb-d71d-47b8-b23d-8ce9295818cb'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','8697c204-abfe-4eb9-ba91-9f48be3bb178'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','55340e58-efc3-414d-acdb-fc99603f00e8'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','a848ad23-6260-48c6-9900-097786ccd93f'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','ad68eefe-64bd-4a37-aa15-5152c5980241'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','e42ab6ad-310a-472e-b0de-4f5088b2ac5a'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','addafc4c-f63f-4f41-99dc-a4e5d7279daa'),
	('bdec427b-619d-4519-bccc-12c402716dc8','180deaa0-0735-40eb-bbd9-6689bae47647'),
	('bdec427b-619d-4519-bccc-12c402716dc8','9f74f60f-6b81-42a2-a9f9-b5f71e18a1f9'),
	('bdec427b-619d-4519-bccc-12c402716dc8','747aa339-ae36-4679-b649-64b916700897'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','239e4745-abb1-47ec-8457-5f9401d52451'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','edc2e71e-a4f0-46fd-be9a-b04f2c57aa51'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','6076a415-b0a4-4975-a500-5979d225d6e2'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','d99314ac-a4ed-4116-b404-88c88eeec608'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','66218fe9-31ff-4ec6-bca3-f37ee8368325'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','e382c8a9-f5c5-4b20-a93a-845a463fabeb'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','58168e19-c1e7-4782-a1fa-73b9782c29e3'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','fee9fd09-9557-4373-b7f5-fa59a2b84272'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','af328a01-c208-4490-98c8-9b38d430c20c'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','bbaf2dfd-bb85-4ae5-bc71-d6edea05d36b'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','ba49869e-52b8-4e5f-a855-9c82903e101b'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','455094ef-19de-4157-972c-9809f55b011f'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','c5041569-e152-4916-98fb-78d5933ca416'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','020241a8-46cc-44c2-b0b7-73337f34a180'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','bbaf2dfd-bb85-4ae5-bc71-d6edea05d36b'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','ba49869e-52b8-4e5f-a855-9c82903e101b'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','455094ef-19de-4157-972c-9809f55b011f'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','c5041569-e152-4916-98fb-78d5933ca416'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','020241a8-46cc-44c2-b0b7-73337f34a180');

INSERT INTO GENRE_TAYANGAN VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','Fantasi'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','Komedi'),
	('bdec427b-619d-4519-bccc-12c402716dc8','Drama'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','Misteri'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','Drama'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','Drama'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','Horor'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','Aksi'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','Drama'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','Dokumenter'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','Animasi'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','Biografi'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','Fantasi'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','Musikal'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','Sci-Fi');

INSERT INTO PERSETUJUAN VALUES ('Paramount','d4c2fa16-11b1-442d-9f34-fd7f1029306b','2022-06-04 00:00:00',56.0,10000.0,'2024-01-31 00:00:00'),
	('Warner Bros','e543fa4c-4b12-4c70-bba2-56e7971c28b0','2022-07-31 00:00:00',53.0,20000.0,'2024-02-03 00:00:00'),
	('A24','c1cb656a-b105-4043-b54b-be24d6c4d5cc','2022-08-07 00:00:00',2.0,30000.0,'2024-02-04 00:00:00'),
	('Lionsgate','ea221dcd-7756-4b8f-80ab-d1a4c04faf13','2022-09-11 00:00:00',3.0,40000.0,'2024-02-06 00:00:00'),
	('Walt Disney Company','bdec427b-619d-4519-bccc-12c402716dc8','2022-10-14 00:00:00',4.0,50000.0,'2024-02-18 00:00:00'),
	('Universal Pictures','3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','2022-10-20 00:00:00',5.0,60000.0,'2024-02-19 00:00:00'),
	('MGM','2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','2022-10-29 00:00:00',7.0,70000.0,'2024-02-21 00:00:00'),
	('Pixar Animation Studios','c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','2022-12-08 00:00:00',8.0,80000.0,'2024-03-06 00:00:00'),
	('20th Century Studios','02b01d9a-fd33-4446-980f-1ebf1a31924f','2022-12-16 00:00:00',12.0,90000.0,'2024-03-07 00:00:00'),
	('Legendary Pictures Productions','05489cf3-aaa4-4513-8445-ece734a7a588','2022-12-20 00:00:00',31.0,100000.0,'2024-03-17 00:00:00'),
	('DreamWorks Animation','7bf5d765-e41a-4065-b94f-339aabd352d6','2023-01-16 00:00:00',42.0,10000.0,'2024-03-21 00:00:00'),
	('Sony Pictures','9636d81b-89ea-4f53-b041-abee6ae8b887','2023-02-19 00:00:00',3.0,20000.0,'2024-03-28 00:00:00'),
	('Falcon Pictures','eb4625d9-e65c-4750-89b3-8366481ad098','2023-04-26 00:00:00',55.0,30000.0,'2024-03-29 00:00:00'),
	('Miles Film','3ca4c372-0068-4df6-a58b-3f7acd23acdc','2023-05-09 00:00:00',23.0,40000.0,'2024-03-31 00:00:00'),
	('MD Pictures','8343b520-aad0-4092-bbd4-b8125bffb9c5','2023-06-09 00:00:00',20.0,50000.0,'2024-04-01 00:00:00'),
	('Paramount','d4c2fa16-11b1-442d-9f34-fd7f1029306b','2023-06-28 00:00:00',3.0,60000.0,'2024-04-04 00:00:00'),
	('Warner Bros','e543fa4c-4b12-4c70-bba2-56e7971c28b0','2023-09-07 00:00:00',88.0,70000.0,'2024-04-07 00:00:00'),
	('A24','c1cb656a-b105-4043-b54b-be24d6c4d5cc','2023-10-12 00:00:00',97.0,80000.0,'2024-04-08 00:00:00'),
	('Lionsgate','ea221dcd-7756-4b8f-80ab-d1a4c04faf13','2023-12-16 00:00:00',76.0,90000.0,'2024-04-15 00:00:00'),
	('Walt Disney Company','bdec427b-619d-4519-bccc-12c402716dc8','2023-12-25 00:00:00',56.0,100000.0,'2024-04-28 00:00:00');

INSERT INTO PENGGUNA VALUES ('hahaha1','hahaha1123','d4c2fa16-11b1-442d-9f34-fd7f1029306b','Indonesia'),
	('hehehe2','hehehe2123','e543fa4c-4b12-4c70-bba2-56e7971c28b0','Indonesia'),
	('huhuhu3','huhuhu3123','c1cb656a-b105-4043-b54b-be24d6c4d5cc','Indonesia'),
	('hohoho4','hohoho4123','ea221dcd-7756-4b8f-80ab-d1a4c04faf13','Indonesia'),
	('hihihi5','hihihi5123','bdec427b-619d-4519-bccc-12c402716dc8','Indonesia'),
	('lalala6','lalala6123','3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','Indonesia'),
	('lilili7','lilili7123','2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','Indonesia'),
	('lululu8','lululu8123','c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','Indonesia');

INSERT INTO TRANSACTION VALUES ('hahaha1','2023-01-01 00:00:00','2024-01-01 00:00:00','Basic','Kartu Kredit','2023-01-01 10:00:00'),
	('hehehe2','2023-02-01 00:00:00','2024-02-01 00:00:00','Premium','Transfer Bank','2023-02-01 11:00:00'),
	('huhuhu3','2023-03-01 00:00:00','2024-03-01 00:00:00','Ultra','Dompet Digital','2023-03-01 12:00:00'),
	('hohoho4','2023-04-01 00:00:00','2024-04-01 00:00:00','Basic','Kartu Kredit','2023-04-01 13:00:00'),
	('hihihi5','2023-05-01 00:00:00','2024-05-01 00:00:00','Premium','Transfer Bank','2023-05-01 14:00:00'),
	('lalala6','2023-06-01 00:00:00','2024-06-01 00:00:00','Ultra','Dompet Digital','2023-06-01 15:00:00'),
	('lilili7','2023-07-01 00:00:00','2024-07-01 00:00:00','Basic','Kartu Kredit','2023-07-01 16:00:00'),
	('lululu8','2023-08-01 00:00:00','2024-08-01 00:00:00','Premium','Transfer Bank','2023-08-01 17:00:00'),
	('hahaha1','2022-07-01 00:00:00','2022-12-31 00:00:00','Ultra','Dompet Digital','2022-07-01 09:00:00'),
	('hehehe2','2022-08-01 00:00:00','2023-01-31 00:00:00','Basic','Kartu Kredit','2022-08-01 10:00:00'),
	('huhuhu3','2022-09-01 00:00:00','2023-02-28 00:00:00','Premium','Transfer Bank','2022-09-01 11:00:00'),
	('hohoho4','2022-10-01 00:00:00','2023-03-31 00:00:00','Ultra','Dompet Digital','2022-10-01 12:00:00'),
	('hihihi5','2022-11-01 00:00:00','2023-04-30 00:00:00','Basic','Kartu Kredit','2022-11-01 13:00:00'),
	('lalala6','2022-12-01 00:00:00','2023-05-31 00:00:00','Premium','Transfer Bank','2022-12-01 14:00:00'),
	('lilili7','2024-07-02 00:00:00','2025-07-01 00:00:00','Ultra','Dompet Digital','2024-07-02 15:00:00'),
	('lululu8','2024-08-02 00:00:00','2025-08-01 00:00:00','Basic','Kartu Kredit','2024-08-02 16:00:00'),
	('hahaha1','2024-11-02 00:00:00','2025-11-01 00:00:00','Premium','Transfer Bank','2024-11-02 17:00:00'),
	('hehehe2','2024-12-02 00:00:00','2025-12-01 00:00:00','Ultra','Dompet Digital','2024-12-02 18:00:00'),
	('huhuhu3','2025-01-02 00:00:00','2026-01-01 00:00:00','Basic','Kartu Kredit','2025-01-02 19:00:00'),
	('hohoho4','2025-02-02 00:00:00','2026-02-01 00:00:00','Premium','Transfer Bank','2025-02-02 20:00:00'),
	('hihihi5','2025-03-02 00:00:00','2026-03-01 00:00:00','Ultra','Dompet Digital','2025-03-02 21:00:00'),
	('lalala6','2025-04-02 00:00:00','2026-04-01 00:00:00','Basic','Kartu Kredit','2025-04-02 22:00:00'),
	('lilili7','2025-05-02 00:00:00','2026-05-01 00:00:00','Premium','Transfer Bank','2025-05-02 23:00:00'),
	('lululu8','2025-06-02 00:00:00','2026-06-01 00:00:00','Ultra','Dompet Digital','2025-06-02 00:00:00');

INSERT INTO ULASAN VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','hahaha1','2024-04-02 12:00:00',5.0,'Outstanding service and quality, highly recommended!'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','hehehe2','2023-03-11 12:30:00',4.0,'Really enjoyed the experience, would definitely return.'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','huhuhu3','2023-12-12 13:00:00',3.0,'Average performance, nothing too memorable.'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','hohoho4','2023-01-02 13:30:00',2.0,'Below expectations in terms of service and quality.'),
	('bdec427b-619d-4519-bccc-12c402716dc8','hihihi5','2023-05-02 14:00:00',5.0,'An unforgettable experience with exceptional attention to detail.'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','lalala6','2023-06-02 14:30:00',4.0,'Good, but not great. Service could be improved.'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','lilili7','2023-05-10 15:00:00',3.0,'Fairly decent but with some noticeable flaws.'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','lululu8','2023-08-03 15:30:00',5.0,'Excellent! Every aspect was perfect.'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','hahaha1','2023-10-01 08:00:00',4.0,'Engaging and thoughtful'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','hehehe2','2024-01-24 09:15:00',3.0,'Interesting but lacks depth'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','huhuhu3','2023-09-05 10:30:00',5.0,'Superbly executed, a must-watch'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','hohoho4','2024-04-04 11:45:00',1.0,'Disappointing and dull'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','hihihi5','2024-01-15 12:00:00',4.0,'Very enjoyable and well-made'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','lalala6','2024-02-12 13:20:00',2.0,'Failed to live up to expectations'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','lilili7','2023-11-22 14:35:00',3.0,'Average, could use more originality'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','lululu8','2024-03-08 15:50:00',5.0,'Exceptional quality and immersive content');

INSERT INTO DAFTAR_FAVORIT VALUES ('2023-01-10 11:11:15','hahaha1','The Crown'),
	('2023-01-27 11:12:15','hehehe2','Inception'),
	('2023-02-13 11:13:15','huhuhu3','Stranger Things'),
	('2023-02-26 11:14:15','hohoho4','The Godfather'),
	('2023-04-05 11:15:15','hihihi5','Game of Thrones'),
	('2023-08-19 11:16:15','lalala6','Pulp Fiction'),
	('2023-09-12 11:17:15','lilili7','Breaking Bad'),
	('2023-10-22 11:18:15','lululu8','Interstellar'),
	('2023-12-11 10:30:20','hahaha1','The Shawshank Redemption'),
	('2023-12-16 10:31:20','hehehe2','Black Mirror'),
	('2023-12-30 10:32:20','huhuhu3','Forrest Gump'),
	('2024-01-07 10:33:20','hohoho4','The Matrix'),
	('2024-02-10 10:34:20','hihihi5','Friends'),
	('2024-02-20 10:35:20','lalala6','The Dark Knight'),
	('2024-02-29 10:36:20','lilili7','The Office'),
	('2024-04-18 10:37:20','lululu8','Schindler''s List');

INSERT INTO TAYANGAN_MEMILIKI_DAFTAR_FAVORIT VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','2023-01-10 11:11:15','hahaha1'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','2023-01-27 11:12:15','hehehe2'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','2023-02-13 11:13:15','huhuhu3'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','2023-02-26 11:14:15','hohoho4'),
	('bdec427b-619d-4519-bccc-12c402716dc8','2023-04-05 11:15:15','hihihi5'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','2023-08-19 11:16:15','lalala6'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','2023-09-12 11:17:15','lilili7'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','2023-10-22 11:18:15','lululu8'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','2023-12-11 10:30:20','hahaha1'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','2023-12-16 10:31:20','hehehe2'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','2023-12-30 10:32:20','huhuhu3'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','2024-01-07 10:33:20','hohoho4'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','2024-02-10 10:34:20','hihihi5'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','2024-02-20 10:35:20','lalala6'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','2024-02-29 10:36:20','lilili7'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','2024-04-18 10:37:20','lululu8');

INSERT INTO RIWAYAT_NONTON VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','hahaha1','2023-04-01 10:00:00','2023-04-01 12:00:00'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','hehehe2','2023-05-02 11:00:00','2023-05-02 11:22:00'),
	('bdec427b-619d-4519-bccc-12c402716dc8','huhuhu3','2023-06-03 12:00:00','2023-06-03 13:05:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','hohoho4','2023-07-04 13:00:00','2023-07-04 14:30:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','hihihi5','2023-08-05 14:00:00','2023-08-05 15:30:00'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','lalala6','2023-09-06 15:00:00','2023-09-06 17:34:00'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','lilili7','2023-10-07 16:00:00','2023-10-07 17:52:00'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','lululu8','2023-11-08 17:00:00','2023-11-08 18:41:00'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','hahaha1','2023-12-09 18:00:00','2023-12-09 20:22:00'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','hehehe2','2024-01-10 19:00:00','2024-01-10 19:41:00'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','huhuhu3','2024-02-11 20:00:00','2024-02-11 21:40:00'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','hohoho4','2024-03-12 21:00:00','2024-03-12 23:41:00'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','hihihi5','2024-04-13 22:00:00','2024-04-13 23:28:00'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','lalala6','2024-05-14 23:00:00','2024-05-15 01:28:00'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','lilili7','2024-06-15 00:00:00','2024-06-15 02:00:00'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','lululu8','2024-07-16 01:00:00','2024-07-16 01:22:00'),
	('bdec427b-619d-4519-bccc-12c402716dc8','hahaha1','2024-08-17 02:00:00','2024-08-17 03:05:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','hehehe2','2024-09-18 03:00:00','2024-09-18 04:30:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','huhuhu3','2024-10-19 04:00:00','2024-10-19 05:30:00'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','hohoho4','2024-11-20 05:00:00','2024-11-20 07:34:00'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','hihihi5','2024-12-21 06:00:00','2024-12-21 07:52:00'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','lalala6','2025-01-22 07:00:00','2025-01-22 08:41:00'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','lilili7','2025-02-23 08:00:00','2025-02-23 10:22:00'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','lululu8','2025-03-24 09:00:00','2025-03-24 09:41:00');

INSERT INTO TAYANGAN_TERUNDUH VALUES ('d4c2fa16-11b1-442d-9f34-fd7f1029306b','hahaha1','2024-02-01 14:23:45'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','hehehe2','2024-02-04 15:34:56'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','huhuhu3','2024-02-03 16:45:07'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','hohoho4','2024-02-05 17:56:18'),
	('bdec427b-619d-4519-bccc-12c402716dc8','hihihi5','2024-02-05 18:07:29'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','lalala6','2024-02-06 19:18:30'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','lilili7','2024-02-07 20:29:41'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','lululu8','2024-02-08 21:40:52'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','lululu8','2024-01-01 08:00:00'),
	('e543fa4c-4b12-4c70-bba2-56e7971c28b0','lalala6','2024-01-02 08:30:00'),
	('c1cb656a-b105-4043-b54b-be24d6c4d5cc','hihihi5','2024-01-03 09:00:00'),
	('ea221dcd-7756-4b8f-80ab-d1a4c04faf13','lilili7','2024-01-04 09:30:00'),
	('bdec427b-619d-4519-bccc-12c402716dc8','hahaha1','2024-01-05 10:00:00'),
	('3755436c-bfd2-4a25-b23b-bfcc43d4b9e3','hehehe2','2024-01-06 10:30:00'),
	('2e0c33a3-1bac-4206-8eeb-2ac6cdf270bd','hohoho4','2024-01-07 11:00:00'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','huhuhu3','2024-01-08 11:30:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','hahaha1','2024-01-09 12:00:00'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','hehehe2','2024-01-10 12:30:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','huhuhu3','2024-01-11 13:00:00'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','hohoho4','2024-01-12 13:30:00'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','hihihi5','2024-01-13 14:00:00'),
	('3ca4c372-0068-4df6-a58b-3f7acd23acdc','lalala6','2024-01-14 14:30:00'),
	('8343b520-aad0-4092-bbd4-b8125bffb9c5','lilili7','2024-01-15 15:00:00'),
	('d4c2fa16-11b1-442d-9f34-fd7f1029306b','lululu8','2024-01-16 15:30:00'),
	('05489cf3-aaa4-4513-8445-ece734a7a588','hahaha1','2024-01-17 16:00:00'),
	('eb4625d9-e65c-4750-89b3-8366481ad098','hehehe2','2024-01-18 16:30:00'),
	('9636d81b-89ea-4f53-b041-abee6ae8b887','huhuhu3','2024-01-19 17:00:00'),
	('7bf5d765-e41a-4065-b94f-339aabd352d6','hohoho4','2024-01-20 17:30:00'),
	('02b01d9a-fd33-4446-980f-1ebf1a31924f','hihihi5','2024-01-21 18:00:00'),
	('c42ef714-3b7d-4fd8-b3e2-9a2c0e9840c0','lalala6','2024-01-22 18:30:00');
