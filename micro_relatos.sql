-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-08-2025 a las 19:05:27
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `micro_relatos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clases_personalizadas`
--

CREATE TABLE `clases_personalizadas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `profesor_id` int(11) DEFAULT NULL,
  `modulo_id` int(11) DEFAULT NULL,
  `fecha_clase` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `duracion_minutos` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'pendiente',
  `precio_pagado` decimal(10,2) DEFAULT NULL,
  `pago_profesor` decimal(10,2) DEFAULT NULL,
  `fecha_pago` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ;

--
-- Volcado de datos para la tabla `clases_personalizadas`
--

INSERT INTO `clases_personalizadas` (`id`, `usuario_id`, `profesor_id`, `modulo_id`, `fecha_clase`, `duracion_minutos`, `estado`, `precio_pagado`, `pago_profesor`, `fecha_pago`) VALUES
(13, 1, 1, 12, '2025-08-25 03:38:40', 60, 'completada', 25.00, NULL, '2025-08-25 03:37:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `escrito_id` int(11) NOT NULL,
  `contenido` text NOT NULL,
  `fecha_comentario` timestamp NOT NULL DEFAULT current_timestamp(),
  `respuesta_a` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escritos`
--

CREATE TABLE `escritos` (
  `id` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `contenido` text NOT NULL,
  `sinopsis` text DEFAULT NULL,
  `portada` varchar(255) DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `genero_id` int(11) DEFAULT NULL,
  `fecha_publicacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) DEFAULT 'publicado',
  `likes_count` int(11) DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `escritos`
--

INSERT INTO `escritos` (`id`, `titulo`, `contenido`, `sinopsis`, `portada`, `usuario_id`, `genero_id`, `fecha_publicacion`, `estado`, `likes_count`) VALUES
(1, 'El primer encuentro', '\"Era una tarde lluviosa cuando sus miradas se encontraron por primera vez...\"', 'Una joven conoce al amor de su vida en una cafetería', 'portada_romance1.jpg', 1, 1, '2025-08-25 02:11:35', 'publicado', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generos`
--

CREATE TABLE `generos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `generos`
--

INSERT INTO `generos` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Romance', 'Historias de amor y relaciones '),
(2, 'Terror ', 'Narrativas de miedo y suspenso '),
(3, 'Fantasía', 'Mundos imaginarios y elementos mágicos ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insignias`
--

CREATE TABLE `insignias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_url` varchar(255) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `insignias`
--

INSERT INTO `insignias` (`id`, `nombre`, `descripcion`, `imagen_url`, `tipo`) VALUES
(14, 'Primeros pasos', 'Completaste tu primer módulo de aprendizaje', 'insignia_primeros_pasos.png', 'modulo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insignias_usuarios`
--

CREATE TABLE `insignias_usuarios` (
  `usuario_id` int(11) NOT NULL,
  `insignia_id` int(11) NOT NULL,
  `fecha_obtencion` timestamp NOT NULL DEFAULT current_timestamp(),
  `modulo_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `insignias_usuarios`
--

INSERT INTO `insignias_usuarios` (`usuario_id`, `insignia_id`, `fecha_obtencion`, `modulo_id`) VALUES
(1, 14, '2025-08-25 03:40:49', 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libros_externos`
--

CREATE TABLE `libros_externos` (
  `id` int(11) NOT NULL,
  `google_id` varchar(100) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `autor` varchar(255) DEFAULT NULL,
  `portada_url` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libros_externos`
--

INSERT INTO `libros_externos` (`id`, `google_id`, `titulo`, `autor`, `portada_url`, `descripcion`, `fecha_actualizacion`) VALUES
(1, 'ISBN123456', 'Cien años de soledad', 'Gabriel García Márquez', '\'https://portadaslibros.com/cien-anos.jpg', '\'Novela emblemática del realismo mágico\'', '2025-08-25 02:14:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libros_populares_semanales`
--

CREATE TABLE `libros_populares_semanales` (
  `id` int(11) NOT NULL,
  `libro_id` int(11) NOT NULL,
  `semana` date NOT NULL,
  `cantidad_reseñas` int(11) DEFAULT 0,
  `promedio_puntuacion` decimal(3,2) DEFAULT NULL,
  `posicion_ranking` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libros_populares_semanales`
--

INSERT INTO `libros_populares_semanales` (`id`, `libro_id`, `semana`, `cantidad_reseñas`, `promedio_puntuacion`, `posicion_ranking`) VALUES
(16, 1, '2025-08-24', 15, 4.70, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `escrito_id` int(11) NOT NULL,
  `fecha_like` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos_aprendizaje`
--

CREATE TABLE `modulos_aprendizaje` (
  `id` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `duracion_horas` int(11) DEFAULT NULL,
  `nivel_dificultad` varchar(20) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `disponible` tinyint(1) DEFAULT 1
) ;

--
-- Volcado de datos para la tabla `modulos_aprendizaje`
--

INSERT INTO `modulos_aprendizaje` (`id`, `titulo`, `descripcion`, `duracion_horas`, `nivel_dificultad`, `precio`, `disponible`) VALUES
(12, 'Introducción a la escritura creativa', 'Aprende los fundamentos de la narrativa', 12, 'Principiante', 49.99, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos_profesores`
--

CREATE TABLE `modulos_profesores` (
  `modulo_id` int(11) NOT NULL,
  `profesor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modulos_profesores`
--

INSERT INTO `modulos_profesores` (`modulo_id`, `profesor_id`) VALUES
(12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesores`
--

CREATE TABLE `profesores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `tarifa_hora` decimal(10,2) DEFAULT NULL,
  `disponible` tinyint(1) DEFAULT 1,
  `calificacion_promedio` decimal(3,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `profesores`
--

INSERT INTO `profesores` (`id`, `nombre`, `especialidad`, `descripcion`, `tarifa_hora`, `disponible`, `calificacion_promedio`) VALUES
(1, 'Carlos Méndez', 'Narrativa corta', 'Escritor profesional con 32 años e experiencia', 25.00, 1, 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reseñas_libros`
--

CREATE TABLE `reseñas_libros` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `libro_id` int(11) NOT NULL,
  `puntuacion` int(11) NOT NULL,
  `reseña_texto` text DEFAULT NULL,
  `fecha_reseña` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `reseñas_libros`
--

INSERT INTO `reseñas_libros` (`id`, `usuario_id`, `libro_id`, `puntuacion`, `reseña_texto`, `fecha_reseña`) VALUES
(1, 1, 1, 5, 'Una obra maestra de la literatura latinoamericana. Maravillosa!', '2025-08-25 02:17:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `retos_completados`
--

CREATE TABLE `retos_completados` (
  `usuario_id` int(11) NOT NULL,
  `reto_id` int(11) NOT NULL,
  `fecha_completado` timestamp NOT NULL DEFAULT current_timestamp(),
  `experiencia_obtenida` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `retos_completados`
--

INSERT INTO `retos_completados` (`usuario_id`, `reto_id`, `fecha_completado`, `experiencia_obtenida`) VALUES
(1, 15, '2025-08-25 03:47:46', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `retos_escritura`
--

CREATE TABLE `retos_escritura` (
  `id` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fecha_fin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `nivel_dificultad` varchar(20) DEFAULT NULL,
  `experiencia_premio` int(11) DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `retos_escritura`
--

INSERT INTO `retos_escritura` (`id`, `titulo`, `descripcion`, `fecha_inicio`, `fecha_fin`, `nivel_dificultad`, `experiencia_premio`) VALUES
(15, 'Reto de Marzo: Micro-Relatos', 'Escribe 5 micro-relatos de máximo 100 palabras cada uno', '2025-08-25 03:47:19', '2025-09-01 03:41:03', 'fácil', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `identificador` varchar(50) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `nombre_perfil` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `experiencia_escritor` int(11) DEFAULT 0,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `nivel_escritor` int(11) DEFAULT 1
) ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `identificador`, `correo`, `contraseña`, `nombre_perfil`, `descripcion`, `experiencia_escritor`, `fecha_registro`, `nivel_escritor`) VALUES
(1, 'maria_escritora', 'maria.lopez@gmail.com', 'hashed_password_123', 'Maria López', 'Escritora novata apasionada por el romance', 0, '2025-08-25 02:07:08', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `watchlist_libros`
--

CREATE TABLE `watchlist_libros` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `libro_id` int(11) NOT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `watchlist_usuarios`
--

CREATE TABLE `watchlist_usuarios` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `escrito_id` int(11) NOT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `watchlist_usuarios`
--

INSERT INTO `watchlist_usuarios` (`id`, `usuario_id`, `escrito_id`, `fecha_agregado`) VALUES
(1, 1, 1, '2025-08-25 02:13:17');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clases_personalizadas`
--
ALTER TABLE `clases_personalizadas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profesor_id` (`profesor_id`),
  ADD KEY `modulo_id` (`modulo_id`),
  ADD KEY `idx_clases_usuario` (`usuario_id`);

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `respuesta_a` (`respuesta_a`),
  ADD KEY `idx_comentarios_escrito` (`escrito_id`);

--
-- Indices de la tabla `escritos`
--
ALTER TABLE `escritos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_escritos_usuario` (`usuario_id`),
  ADD KEY `idx_escritos_genero` (`genero_id`);

--
-- Indices de la tabla `generos`
--
ALTER TABLE `generos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `insignias`
--
ALTER TABLE `insignias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `insignias_usuarios`
--
ALTER TABLE `insignias_usuarios`
  ADD PRIMARY KEY (`usuario_id`,`insignia_id`),
  ADD KEY `insignia_id` (`insignia_id`),
  ADD KEY `modulo_id` (`modulo_id`);

--
-- Indices de la tabla `libros_externos`
--
ALTER TABLE `libros_externos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- Indices de la tabla `libros_populares_semanales`
--
ALTER TABLE `libros_populares_semanales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `libro_id` (`libro_id`,`semana`);

--
-- Indices de la tabla `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario_id` (`usuario_id`,`escrito_id`),
  ADD KEY `idx_likes_escrito` (`escrito_id`);

--
-- Indices de la tabla `modulos_aprendizaje`
--
ALTER TABLE `modulos_aprendizaje`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `modulos_profesores`
--
ALTER TABLE `modulos_profesores`
  ADD PRIMARY KEY (`modulo_id`,`profesor_id`),
  ADD KEY `profesor_id` (`profesor_id`);

--
-- Indices de la tabla `profesores`
--
ALTER TABLE `profesores`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `reseñas_libros`
--
ALTER TABLE `reseñas_libros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario_id` (`usuario_id`,`libro_id`),
  ADD KEY `idx_reseñas_libro` (`libro_id`);

--
-- Indices de la tabla `retos_completados`
--
ALTER TABLE `retos_completados`
  ADD PRIMARY KEY (`usuario_id`,`reto_id`),
  ADD KEY `reto_id` (`reto_id`);

--
-- Indices de la tabla `retos_escritura`
--
ALTER TABLE `retos_escritura`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_retos_fechas` (`fecha_inicio`,`fecha_fin`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identificador` (`identificador`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `watchlist_libros`
--
ALTER TABLE `watchlist_libros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario_id` (`usuario_id`,`libro_id`),
  ADD KEY `libro_id` (`libro_id`);

--
-- Indices de la tabla `watchlist_usuarios`
--
ALTER TABLE `watchlist_usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario_id` (`usuario_id`,`escrito_id`),
  ADD KEY `escrito_id` (`escrito_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clases_personalizadas`
--
ALTER TABLE `clases_personalizadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `escritos`
--
ALTER TABLE `escritos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `generos`
--
ALTER TABLE `generos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `insignias`
--
ALTER TABLE `insignias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `libros_externos`
--
ALTER TABLE `libros_externos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `libros_populares_semanales`
--
ALTER TABLE `libros_populares_semanales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `modulos_aprendizaje`
--
ALTER TABLE `modulos_aprendizaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `profesores`
--
ALTER TABLE `profesores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `reseñas_libros`
--
ALTER TABLE `reseñas_libros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `retos_escritura`
--
ALTER TABLE `retos_escritura`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `watchlist_libros`
--
ALTER TABLE `watchlist_libros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `watchlist_usuarios`
--
ALTER TABLE `watchlist_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clases_personalizadas`
--
ALTER TABLE `clases_personalizadas`
  ADD CONSTRAINT `clases_personalizadas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `clases_personalizadas_ibfk_2` FOREIGN KEY (`profesor_id`) REFERENCES `profesores` (`id`),
  ADD CONSTRAINT `clases_personalizadas_ibfk_3` FOREIGN KEY (`modulo_id`) REFERENCES `modulos_aprendizaje` (`id`);

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`escrito_id`) REFERENCES `escritos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_3` FOREIGN KEY (`respuesta_a`) REFERENCES `comentarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `escritos`
--
ALTER TABLE `escritos`
  ADD CONSTRAINT `escritos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `escritos_ibfk_2` FOREIGN KEY (`genero_id`) REFERENCES `generos` (`id`);

--
-- Filtros para la tabla `insignias_usuarios`
--
ALTER TABLE `insignias_usuarios`
  ADD CONSTRAINT `insignias_usuarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `insignias_usuarios_ibfk_2` FOREIGN KEY (`insignia_id`) REFERENCES `insignias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `insignias_usuarios_ibfk_3` FOREIGN KEY (`modulo_id`) REFERENCES `modulos_aprendizaje` (`id`);

--
-- Filtros para la tabla `libros_populares_semanales`
--
ALTER TABLE `libros_populares_semanales`
  ADD CONSTRAINT `libros_populares_semanales_ibfk_1` FOREIGN KEY (`libro_id`) REFERENCES `libros_externos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`escrito_id`) REFERENCES `escritos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `modulos_profesores`
--
ALTER TABLE `modulos_profesores`
  ADD CONSTRAINT `modulos_profesores_ibfk_1` FOREIGN KEY (`modulo_id`) REFERENCES `modulos_aprendizaje` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `modulos_profesores_ibfk_2` FOREIGN KEY (`profesor_id`) REFERENCES `profesores` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reseñas_libros`
--
ALTER TABLE `reseñas_libros`
  ADD CONSTRAINT `reseñas_libros_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reseñas_libros_ibfk_2` FOREIGN KEY (`libro_id`) REFERENCES `libros_externos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `retos_completados`
--
ALTER TABLE `retos_completados`
  ADD CONSTRAINT `retos_completados_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `retos_completados_ibfk_2` FOREIGN KEY (`reto_id`) REFERENCES `retos_escritura` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `watchlist_libros`
--
ALTER TABLE `watchlist_libros`
  ADD CONSTRAINT `watchlist_libros_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `watchlist_libros_ibfk_2` FOREIGN KEY (`libro_id`) REFERENCES `libros_externos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `watchlist_usuarios`
--
ALTER TABLE `watchlist_usuarios`
  ADD CONSTRAINT `watchlist_usuarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `watchlist_usuarios_ibfk_2` FOREIGN KEY (`escrito_id`) REFERENCES `escritos` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
