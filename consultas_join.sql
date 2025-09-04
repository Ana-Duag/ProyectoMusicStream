/* CONSULTAS CON JOIN
Utilizamos alias para mejor legibilidad del código y buenas prácticas de SQL */

-- 1. ARTISTAS QUE TIENEN CANCIONES REGISTRADAS --
-- Si un artista no tiene canciones, no aparecerá --

SELECT a.Artist, a.Listeners, c.name_track, c.genre, c.year
FROM artistas a
INNER JOIN canciones c
  ON a.Artist = c.name_artist
ORDER BY a.Listeners DESC;


-- 2. DEVUELVE TODOS LOS ARTISTAS Y TODAS LAS CANCIONES --
SELECT a.Artist, c.name_track, c.genre, c.year
FROM artistas a
FULL OUTER JOIN canciones c
  ON a.Artist = c.name_artist;
  
-- Si un artista no tiene canciones → columnas de canciones serán NULL.
-- Si una canción no tiene artista registrado → columnas de artistas serán NULL.


-- 3. CRUZAR LA TABLA ARTISTAS CONSIGO MISMA PARA RELACIONAR ARTISTAS CON ARTISTAS SIMILARES --
SELECT a1.Artist AS Artist1, a2.Artist AS Artist2
FROM artistas a1
INNER JOIN artistas a2
  ON a2.Artist = ANY (string_to_array(a1.SimilarArtists, ','));
  

-- 4. TOP DE 5 CANCIONES POR GÉNERO --
SELECT Artist, Listeners, name_track, genre, year
FROM (
    SELECT 
        a.Artist,
        a.Listeners,
        c.name_track,
        c.genre,
        c.year,
        ROW_NUMBER() OVER (PARTITION BY c.genre ORDER BY a.Listeners DESC) AS rn
    FROM artistas a
    INNER JOIN canciones c
      ON a.Artist = c.name_artist
) sub
WHERE rn <= 5
ORDER BY genre, rn;


-- 5.TOP DE 5 ARTISTAS MÁS ESCUCHADOS POR GÉNERO --
SELECT Artist, Listeners, genre
FROM (
    SELECT 
        a.Artist,
        a.Listeners,
        c.genre,
        ROW_NUMBER() OVER (PARTITION BY c.genre ORDER BY a.Listeners DESC) AS rn
    FROM artistas a
    INNER JOIN canciones c
      ON a.Artist = c.name_artist
    GROUP BY a.Artist, a.Listeners, c.genre
) sub
WHERE rn <= 5
ORDER BY genre, rn;


-- 6. ARTISTAS CON MÁS CANCIONES EN LA BASE DE DATOS
SELECT a.Artist, COUNT(c.name_track) AS total_canciones
FROM artistas a
INNER JOIN canciones c
  ON a.Artist = c.name_artist
GROUP BY a.Artist
ORDER BY total_canciones DESC;


-- 7. 5  ARTISTAS CON MÁS ESCUCHAS EN LOS ÚLTIMOS 5 AÑOS  --
SELECT a.Artist, SUM(a.Listeners) AS total_listeners
FROM artistas a
INNER JOIN canciones c
  ON a.Artist = c.name_artist
WHERE c.year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY a.Artist
ORDER BY total_listeners DESC
LIMIT 5;


-- DEVUELVE TODOS LOS ARTISTAS, INCLUSO SI NO TIENEN CANCIONES
SELECT a.Artist, c.name_track, c.genre, c.year
FROM artistas a
LEFT JOIN canciones c
  ON a.Artist = c.name_artist;


-- Para los artistas sin canciones, las columnas de canciones serán NULL.


-- DEVUELVE TODAS LAS CANCIONES, INCLUSO SI EL ARTISTA NO ESTÁ EN LA TABLA ARTISTAS
SELECT a.Artist, c.name_track, c.genre, c.year
FROM artistas a
RIGHT JOIN canciones c
  ON a.Artist = c.name_artist;

-- Para las canciones sin artista registrado en artistas, las columnas de artistas serán NULL.


