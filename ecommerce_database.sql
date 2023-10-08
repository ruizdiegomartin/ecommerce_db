
#SCHEMA CREATION
CREATE SCHEMA ecommerce_db;

#SCHEMA USE
USE ecommerce_db;

# -----------------------------------------------------------------------------------------------------------------------------------------------

# DDL SENTENCES: TABLES CREATIONS AND KEYS

CREATE TABLE `user` (
	`id_user` int NOT NULL AUTO_INCREMENT,
	`username` varchar(30) NOT NULL,
	`login_password` varchar(50) NOT NULL,
	`email` varchar(50) NOT NULL,
	`first_name` varchar(30) NOT NULL,
	`last_name` varchar(30) NOT NULL,
	`address` varchar(50) NOT NULL,
	`location` int NOT NULL,
	PRIMARY KEY (`id_user`),
	UNIQUE KEY `idx_username` (`username`),
	UNIQUE KEY `idx_user_email` (`email`)
);

CREATE TABLE `cart` (
	`id_cart` int NOT NULL AUTO_INCREMENT,
	`user_id` int NOT NULL,
	`date_created` datetime,
	`checkout_status` bit(1) NOT NULL,
	PRIMARY KEY (`id_cart`)
);

CREATE TABLE `cart_product` (
	`id` int NOT NULL AUTO_INCREMENT,
	`cart_id` int NOT NULL,
	`product_id` int NOT NULL,
	`quantity` int NOT NULL DEFAULT 1,
	`date_added` datetime,
	PRIMARY KEY (`id`)
);

CREATE TABLE `product` (
	`id_product` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL,
	`price` float NOT NULL,
	`stock` int NOT NULL,
	`variety` int NOT NULL DEFAULT 1,
	`category` int NOT NULL DEFAULT 1,
	`discount` int NOT NULL DEFAULT 1,
	PRIMARY KEY (`id_product`)
);

CREATE TABLE `purchase_order` (
	`id_order` INT AUTO_INCREMENT,
	`cart_id` INT NOT NULL,
	`user_id` INT NOT NULL,
    `total_price` FLOAT NOT NULL DEFAULT 0,
    `currency` INT NOT NULL,
    `payment_method` ENUM('Bank transfer','Debit','Credit') NOT NULL,
	`payment_status` INT NOT NULL,
	`order_date` DATETIME NOT NULL,
    `shipment_status` INT NOT NULL,
    PRIMARY KEY (`id_order`)
);

CREATE TABLE `claim` (
	`id` INT AUTO_INCREMENT,
    `type` INT NOT NULL,
    `comment` TEXT(255) NOT NULL,
    `claim_status` INT NOT NULL,
    `order_id` INT NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `product_category` (
	`id` INT AUTO_INCREMENT,
    `category` VARCHAR(55) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `product_variety` (
	`id` INT AUTO_INCREMENT,
    `variety` VARCHAR(55) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `discount` (
	`id` INT AUTO_INCREMENT,
    `type` VARCHAR(55) NOT NULL,
    `value` INT NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `favorite` (
	`id` INT AUTO_INCREMENT,
    `product_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `date_added` datetime,
    PRIMARY KEY (`id`)
);

CREATE TABLE `location` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(55) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `status` (
	`id` INT AUTO_INCREMENT,
    `value` VARCHAR(55) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `claim_type` (
	`id` INT AUTO_INCREMENT,
    `type` VARCHAR(55) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `currency` (
	`id` INT AUTO_INCREMENT,
    `value` VARCHAR(6) NOT NULL,
    `description` VARCHAR(55) NOT NULL,
    PRIMARY KEY (`id`)
);

# FOREING KEYS (FK) ASSIGNATION

SELECT * FROM purchase_order;
SELECT * FROM status;

ALTER TABLE `user`
ADD CONSTRAINT FK_UserLocation FOREIGN KEY(`location`) REFERENCES `location`(`id`);

ALTER TABLE `claim`
ADD CONSTRAINT FK_ClaimStatus FOREIGN KEY(`claim_status`) REFERENCES `status`(`id`),
ADD CONSTRAINT FK_ClaimType FOREIGN KEY(`type`) REFERENCES `claim_type`(`id`),
ADD CONSTRAINT FK_ClaimOrder FOREIGN KEY(`order_id`) REFERENCES `purchase_order`(`id_order`);

ALTER TABLE `cart`
ADD CONSTRAINT FK_CartUser FOREIGN KEY(`user_id`) REFERENCES `user`(`id_user`);

ALTER TABLE `cart_product`
ADD CONSTRAINT FK_CartCart FOREIGN KEY(`cart_id`) REFERENCES cart(`id_cart`),
ADD CONSTRAINT FK_CartProduct FOREIGN KEY(`product_id`) REFERENCES product(`id_product`);

ALTER TABLE `product`
ADD CONSTRAINT FK_ProductCategory FOREIGN KEY(`category`) REFERENCES `product_category`(`id`),
ADD CONSTRAINT FK_ProductVariety FOREIGN KEY(`variety`) REFERENCES `product_variety`(`id`),
ADD CONSTRAINT FK_ProductDiscount FOREIGN KEY(`discount`) REFERENCES `discount`(`id`);

ALTER TABLE `purchase_order`
ADD CONSTRAINT FK_OrderCart FOREIGN KEY(`cart_id`) REFERENCES `cart`(`id_cart`),
ADD CONSTRAINT FK_OrderUser FOREIGN KEY(`user_id`) REFERENCES `user`(`id_user`),
ADD CONSTRAINT FK_OrderCurrency FOREIGN KEY(`currency`) REFERENCES `currency`(`id`),
ADD CONSTRAINT FK_OrderPaymentStatus FOREIGN KEY(`payment_status`) REFERENCES `status`(`id`),
ADD CONSTRAINT FK_OrderShipmentStatus FOREIGN KEY(`shipment_status`) REFERENCES `status`(`id`);

ALTER TABLE `favorite`
ADD CONSTRAINT FK_FavoriteProduct FOREIGN KEY(`product_id`) REFERENCES product(`id_product`),
ADD CONSTRAINT FK_FavoriteUser FOREIGN KEY(`user_id`) REFERENCES `user`(`id_user`);

# -----------------------------------------------------------------------------------------------------------------------------------------------

# DML: DATA INSERT

SELECT * FROM `location`;
INSERT INTO `location` (`name`) VALUES 
('Buenos Aires'),
('Ciudad Autónoma de Buenos Aires'),
('Catamarca'),
('Chaco'),
('Chubut'),
('Córdoba'),
('Corrientes'),
('Entre Ríos'),
('Formosa'),
('Jujuy'),
('La Pampa'),
('La Rioja'),
('Mendoza'),
('Misiones'),
('Neuquén'),
('Río Negro'),
('Salta'),
('San Juan'),
('Santa Cruz'),
('Santa Fe'),
('Santiago del Estero'),
('Tierra del Fuego'),
('Tucumán');

SELECT * FROM `status`;
INSERT INTO `status` (`value`) VALUES
('Aguardando pago'),
('Pago confirmado'),
('Pago rechazado'),
('Preparando envío'),
('Envío exitoso'),
('Envío fallido'),
('Reclamo iniciado'),
('Reclamo en proceso'),
('Reclamo resuelto'),
('Reclamo rechazado')
;

INSERT INTO `claim_type` (`type`) VALUES
('No me llegó el envío'),
('No es lo que pedí'),
('Cantidad del producto errónea'),
('Producto recibido en mal estado'),
('Producto defectuoso'),
('Otro');

INSERT INTO `discount` (`type`, `value`) VALUES
('Ninguna', 0),
('Promoción bancaria', 10),
('Promoción bancaria especial', 20),
('Promoción del día', 10),
('Cyber Monday', 30),
('Black Friday', 30),
('Liquidación', 50);

INSERT INTO `product_category` (`category`) VALUES 
('sin especificar'),
('velas'),
('jabones'),
('difusores'),
('splash'),
('aromatizadores'),
('sahumerios'),
('esencias'),
('otros');

INSERT INTO `product_variety` (`variety`) VALUES 
('sin específicar'),
('colírio'),
('limón'),
('flynn-paff'),
('menta y naranja'),
('cher'),
('pitanga'),
('sandía y frambuesa'),
('eucalípto'),
('palo santo'),
('jazmín'),
('colírio'),
('frutos rojos'),
('vainilla');

INSERT INTO `currency` (`value`, `description`) VALUES
('ARS', 'Peso Argentino'),
('USD', 'Dolar'),
('BTC', 'Bitcoin'),
('EUR', 'Euro'),
('BRL', 'Real'),
('CLP', 'Peso Chileno'),
('UYU', 'Peso Uruguayo'),
('PYG', 'Guarani');

INSERT INTO `user` (`username`, `login_password`, `email`, `first_name`, `last_name`, `address`, `location`) VALUES 
('diegoo10', 'aCEvX324$', 'diego.martin@gmail.com', 'Diego', 'Martin', 'Av. Rivadavia 10231', 2),
('angeladanvers', 'angEL$21szx', 'angeladanvers@gmail.com', 'Angela', 'Danvers', 'Glaston 334', 6),
('lourdessflow', '38480sXs&', 'lourdesprincess@yahoo.com.ar', 'Lourdes', 'Gucci', 'Cnel. Fran Rivarte 104', 12),
('juanb3', 'u324j098m5utb34', 'juanii_23@gmail.com', 'Juan', 'Salas', 'Trenquelauquen 1578', 15),
('tomas.sali22', 'h097n8ar3yv3w', 'tomas.salii@gmail.com', 'Tomas', 'Salinas', 'Pasaje Rivera 558', 20),
('giseromaa2', 'fj34098rtDERF', 'gise_roma@gmail.com', 'Gisell', 'Roma', 'Av. Tirufan 1234', 21),
('maurii.30', 'AN98UFfsdsdSA', 'maurii@outlook.com', 'Mauricio', 'Lopez', 'Av. Roca 3422', 15),
('camiilitaa_star', 'as3sazL$21szx', 'camiliiita@yahoo.com.ar', 'Camila', 'Solano', 'Gascon 748', 2),
('rosalia77', '8snfFJ8fj', 'rosaliaf@gmail.com', 'Rosalía', 'Fuentes', 'Av. Don Bosco 1889', 1),
('jessij', 'a2134355324$$', 'jessi_j@gmail.com', 'Jessica', 'Juarez', 'Psje. Sinatra 343', 1),
('lucio12', '89fdkojsfHFS34$&', 'lucio.la12@outlook.com', 'Lucio', 'Delgado', 'Av. de Mayo 2523', 1),
('delfina.prietto', 'a94490328FSDAFXzxx', 'deelfiprie@gmail.com', 'Delfina', 'Prietto', 'Saleberry 3334', 8),
('nerea.lopez2', '83JFjsu6&', 'nereaperez@hotmail.com', 'Nerea', 'Lopez', 'Saladillo 164', 3),
('vanee1', 'a9d3sdX', 'vane.bocco@gmail.com', 'Vanesa', 'Bocco', 'Miguel Suarez 112', 9),
('pablope', 'sad7878xx', 'perezpablo@outlook.com', 'Pablo', 'Perez', 'Av. De La Cruz 1230', 13),
('julii23', 'a94490328FSasda21DAFXzxx', 'juliangomez23@gmail.com', 'Julian', 'Gomez', 'Av. Trujillo 723', 16);

INSERT INTO `product` (`name`, `price`, `stock`, `variety`, `category`, `discount`) VALUES
('vela de soja jazmín', 1250, 10, 5, 2, 2),
('vela de soja colírio', 1250, 8, 2, 2, 1),
('vela de soja eucalípto', 1250, 8, 9, 2, 4),
('vela de soja sandía y frambuesa', 1250, 2, 8, 2, 1),
('vela de soja menta y naranja', 1250, 15, 5, 2, 1),
('jabon flor limón', 650.5, 20, 3, 3, 6),
('jabon flor pitanga', 650.5, 16, 7, 3, 1),
('jabon con semillas frutos rojos', 850.5, 10, 13, 3, 1),
('jabon con semillas vainilla', 850.5, 15, 14, 3, 1),
('difusor limón', 1300, 20, 3, 4, 1),
('difusor vainilla', 1300, 10, 14, 4, 2),
('difusor menta y naranja', 1300, 5, 5, 4, 1),
('difusor sandía y frambuesa', 1300, 23, 8, 4, 1),
('splash limón', 1300, 10, 3, 5, 1),
('splash flynn-paff', 1300, 10, 4, 5, 4),
('splash cher', 1300, 10, 6, 5, 1),
('splash vainilla', 1300, 10, 14, 5, 1),
('aromatizador cher', 1000, 10, 6, 6, 1),
('aromatizador pitanga', 1000, 12, 7, 6, 2),
('aromatizador jazmín', 1000, 15, 11, 6, 1),
('sahumerio de limón', 250, 30, 3, 7, 6),
('sahumerio de eucalípto', 250, 21, 8, 7, 1),
('sahumerio de palo santo', 250, 28, 9, 7, 1),
('sahumerio de jazmín', 250, 9, 11, 7, 1),
('esencia de vainilla', 2230, 11, 13, 8, 4),
('esencia de limon', 2230, 12, 3, 8, 4),
('esencia de eucalipto', 2230, 12, 9, 8, 4),
('base porta-sahumerio', 500, 20, 1, 9, 1);

INSERT INTO cart (`user_id`, `date_created`, `checkout_status`) VALUES
(1, '2020-04-25 18:52:32', 0),
(2, '2022-02-16 11:00:34', 1),
(3, '2021-05-19 05:30:24', 0),
(5, '2023-04-21 18:20:12', 1),
(7, '2023-09-15 17:12:34', 1),
(9, '2022-11-10 12:13:00', 0),
(12, '2023-01-16 22:15:10', 1),
(13, '2023-05-05 13:43:00', 0),
(14, '2022-12-10 12:33:24', 0),
(16, '2023-09-27 15:33:00', 1),
(2, '2023-09-12 23:03:52', 1),
(5, '2023-07-17 16:22:34', 1),
(7, '2023-09-17 19:20:30', 0),
(15, '2023-05-24 17:00:00', 1),
(12, '2023-05-28 11:42:49', 1),
(16, '2023-08-12 21:48:52', 0);

INSERT INTO cart_product (`cart_id`, `product_id`, `quantity`, `date_added`) VALUES
(1, 7, 2, '2020-04-25 18:52:32'),
(2, 2, 3, '2022-02-16 12:02:04'),
(2, 15, 1, '2022-02-16 12:05:24'),
(4, 4, 1, '2023-04-21 18:22:02'),
(5, 13, 2, '2023-04-21 18:25:50'),
(7, 1, 1, '2023-09-15 17:12:34'),
(9, 3, 2, '2022-12-10 12:35:14'),
(9, 8, 1, '2022-12-10 12:35:14'),
(10, 1, 1, '2023-09-15 17:12:34'),
(10, 17, 3, '2023-09-15 17:13:22'),
(10, 7, 2, '2023-09-15 17:15:04'),
(11, 9, 2, '2023-09-12 23:03:52'),
(12, 1, 1, '2023-07-17 16:22:34'),
(12, 9, 3, '2023-07-17 16:23:03'),
(12, 15, 2, '2023-07-17 16:24:33'),
(12, 17, 1, '2023-07-17 16:26:27'),
(13, 6, 2, '2023-09-17 19:20:30'),
(14, 3, 8, '2023-05-24 17:00:00'),
(15, 12, 1, '2023-05-28 11:42:49'),
(15, 11, 2, '2023-05-28 11:42:49'),
(16, 6, 2, '2023-08-12 21:48:52'),
(16, 3, 1, '2023-08-12 21:48:52');

INSERT INTO `favorite` (`product_id`, `user_id`, `date_added`) VALUES
(1, 1, '2023-05-13 12:00:21'),
(5, 1, '2023-06-03 16:04:21'),
(3, 1, '2022-09-23 22:40:21'),
(4, 2, '2023-09-07 05:28:01'),
(13, 5, '2023-02-01 16:46:32'),
(2, 6, '2023-02-17 18:59:48'),
(4, 6, '2023-07-29 11:10:21'),
(8, 8, '2022-05-03 10:07:51'),
(4, 9, '2023-05-13 14:58:00'),
(1, 9, '2023-06-16 02:25:21'),
(1, 10, '2023-01-12 12:03:34'),
(16, 10, '2023-08-13 22:06:00'),
(5, 10, '2023-03-12 12:00:27'),
(3, 13, '2023-09-07 08:48:22'),
(18, 14, current_date());

INSERT INTO `purchase_order` (`cart_id`, `user_id`, `total_price`, `currency`, `payment_method`, `payment_status`, `order_date`, `shipment_status`) VALUES
(2, 2, 5050, 1, 'Bank transfer', 2, '2022-02-16 12:05:54', 5),
(4, 5, 1250, 1, 'Credit', 2, '2023-04-21 18:23:30', 5),
(5, 7, 2600, 1, 'Credit', 3, '2023-04-21 18:25:58', 1),
(7, 12, 1250, 1, 'Credit', 2, '2023-09-15 17:14:00', 5),
(10, 16, 6451, 1, 'Bank transfer', 2, '2023-09-15 17:15:45', 5),
(11, 2, 1701, 1, 'Debit', 2, '2023-09-12 23:04:26', 4),
(12, 5, 7701.5, 1, 'Credit', 2, '2023-07-17 16:26:59', 6),
(14, 15, 10000, 1, 'Bank transfer', 1, '2023-05-24 17:01:22', 1),
(15, 12, 3900, 1, 'Debit', 2, '2023-05-28 11:43:37', 6);

INSERT INTO `claim` (`type`, `comment`, `claim_status`, `order_id`) VALUES
(1 ,'No pude recibir el pedido porque no estaba en mi casa, ¿pueden volver a enviarlo?', 7, 4),
(4 ,'El paquete llego abierto y roto, no lo recibí', 7, 9),
(6, 'Me rechazaron el pago desde la tarjeta de crédito', 8, 3);

# -----------------------------------------------------------------------------------------------------------------------------------------------

# VIEWS

CREATE VIEW cart_items AS ( 
/* Esta vista permite observar los productos que los usuarios han agregado a sus carritos. Además, está ordenada por usuario para facilitar el análisis de los datos de la misma. 
Podría por ejemplo analizar cual el producto que más eligen los usuarios, cuál es el que mayor cantidad compran, qué usuario tiene mas productos, entre otros datos.*/
	SELECT u.username AS `usuario`, cp.cart_id AS `carrito`, p.`name` AS `producto`, cp.quantity AS `cantidad`, cp.date_added AS `fecha_agregado` FROM `cart_product` cp 
	JOIN product p
	ON cp.product_id = p.id_product
	JOIN cart c
	ON c.id_cart = cp.cart_id
	JOIN `user` u
	ON c.user_id = u.id_user
	ORDER BY usuario
);

#SELECT * FROM cart_items;

CREATE VIEW user_location AS (
/* Esta vista sencilla me permite conocer de que provincia son los usuarios de mi tienda. 
A partir de ella puedo ver de qué provincia tengo mas usuarios, de cuál menos, y poder usar esta información para planear estrategias de marketing. */
	SELECT CONCAT(u.last_name, ', ', u.first_name ) AS nombre_y_apellido, l.`name` as provincia FROM `user` u
	JOIN location l
	ON u.location = l.id
	ORDER BY l.`name`
);

#SELECT * FROM user_location;

CREATE VIEW user_favorites_many AS (
/* Esta vista me informa los usuarios que tienen más de un producto agregado en favoritos (también me indica la cantidad total). 
Esto me permitiría emplear alguna estrategia de marketing para intentar vender esos productos a los usuarios que los destacaron. */
	SELECT u.username, COUNT(*) as favorites_products_amount FROM favorite f
	JOIN user u
	ON f.user_id = u.id_user
	GROUP BY u.username
	HAVING COUNT(*)> 1
);

#SELECT * FROM user_favorites_many;

CREATE VIEW `claim_view` AS (
/* Esta vista me permite mantener un control sobre los reclamos iniciados por los usuarios que efectuaron una compra, 
siendo fácil de comprender para cualquier empleado que pudiera hacer el seguimiento.  */
	SELECT c.`id` AS `id_reclamo`, u.`username` AS `usuario`, c.`order_id` AS `orden_compra`, ct.`type` AS `tipo_de_reclamo`, c.`comment` AS `comentario`, s.`value` AS `estado` FROM `claim` c
	JOIN `claim_type` ct
	ON ct.id = c.type
	JOIN status s
	ON c.`claim_status` = s.`id`
	JOIN `purchase_order` po
	ON po.`id_order` = c.`order_id`
	JOIN `user` u
	ON u.`id_user` = po.`user_id`
);

#SELECT * FROM claim_view;

CREATE VIEW product_catalogue AS (
/* Esta vista me muestra el catálogo de productos vende la tienda y su información principal como variedades, precios y si tiene alguna promocion vigente. 
Está ordenada por el nombre del producto.  */
	SELECT p.name AS producto, p.price AS precio, pv.variety AS variedad, pc.category AS categoria, p.id_product AS id, sd.`type` AS promoción FROM product p
	LEFT JOIN product_variety pv
	ON p.variety = pv.id
	LEFT JOIN product_category pc
	ON p.category = pc.id
	LEFT JOIN discount sd
	ON p.discount = sd.id
	ORDER BY producto
);

#SELECT * FROM product_catalogue;

CREATE VIEW purchase_info AS (
/* Esta vista me detalla la información de las compras realizadas en la tienda, donde puede observar 
los detalles de la misma e incluso hacer el seguimiento de los pagos y del estado del envío.  */
	SELECT po.id_order AS id_orden, u.username AS usuario, po.cart_id AS carritoID, po.total_price AS precio_total, c.value AS moneda, po.payment_method AS metodo_pago, s_2.value AS estado_pago, po.order_date AS fecha_compra, s.value AS estado_envio FROM purchase_order po
	JOIN `user` u
	ON u.id_user = po.user_id
	JOIN currency c
	ON po.currency = c.id
	JOIN status s
	ON po.shipment_status = s.id
	JOIN status s_2
	ON po.payment_status = s_2.id
);

#SELECT * FROM purchase_info;

CREATE VIEW user_total_purchase AS (
/* Esta vista me muestra la suma de dinero en total (puede haber más de una compra de un mismo cliente) de cada usuario que compró en la tienda. 
Con esta información podría ofrecer algún beneficio a los usuarios que más compraron. */
	SELECT u.username, SUM(total_price) AS compra_total FROM purchase_order po
	JOIN `user` u
	ON u.id_user = po.user_id
	GROUP BY user_id
);

#SELECT * FROM user_total_purchase;

# -----------------------------------------------------------------------------------------------------------------------------------------------

# FUNCTIONS 

#FUNCTION 1
DELIMITER $$
CREATE FUNCTION `get_product_price` (productID INT) RETURNS FLOAT
# Esta función recibe el ID de un producto por parámetro y devuelve el precio de dicho producto. Sirve para conocer el precio de un producto a través de su ID.
DETERMINISTIC
BEGIN
	DECLARE price_found FLOAT;
	SELECT price INTO price_found FROM product 
	WHERE id_product = productID;
    RETURN price_found;
END
$$
DELIMITER ;

#SELECT get_product_price(17) AS precio_del_producto;

# FUNCTION 2
DELIMITER $$
CREATE FUNCTION `check_stock`(productID INT) RETURNS VARCHAR(55)
/* Esta función se la utiliza para conocer el estado de stock de un producto para saber si hay que reponerlo en la brevedad o no.
Recibe el ID del producto por parámetro, busca el stock correspondiente a ese producto y devuelve el mensaje (string) correspondiente. */
DETERMINISTIC
BEGIN
	DECLARE stock_quantity INT;
	SELECT `stock` INTO stock_quantity FROM product WHERE `id_product` = productID;
	CASE
		WHEN stock_quantity =0 THEN
		RETURN 'ALERTA: Producto agotado.';
		WHEN stock_quantity <=5 THEN
		RETURN 'ADVERTERNCIA: Poco stock.';
		WHEN stock_quantity >5 AND stock_quantity <=20 THEN
		RETURN 'Stock suficiente de producto.';
		WHEN stock_quantity >20 THEN
		RETURN 'ADVERTENCIA: Exceso de stock.';
    END CASE;
END
$$
DELIMITER ;

#SELECT check_stock(4) AS cantidad_de_stock;
	
# FUNCTION 3
DELIMITER $$
CREATE FUNCTION `change_username` (old_username VARCHAR(30), new_username VARCHAR(30)) RETURNS VARCHAR(30)
# Esta función actualiza el username de un usuario. Recibe por parámetro primero el nombre de usuario a modificar, y luego el nuevo nombre a reemplazar. 
DETERMINISTIC
BEGIN
    UPDATE `user` SET username = new_username WHERE username = old_username;
    RETURN new_username;
END
$$
DELIMITER ;

#SELECT change_username('diegoo10', 'diegoo.martin');
#SELECT * FROM user;

# FUNCTION 4
DELIMITER $$
CREATE FUNCTION `decrease_stock` (productID INT, quantity INT) RETURNS VARCHAR(80)
/* Esta función se utiliza para decrementar la cantidad de stock vendida de un producto. Como primer parámetro recibe el ID del producto, 
y como segundo parámetro la cantidad a decrementar. Si la cantidad que se quiere decrementar es mayor al stock que hay del producto, no decrementa y retorna un mensaje de error.
Si el decremento tiene éxito, retorna un mensaje confirmado la acción y mostrando el stock remanente actualizado.*/
DETERMINISTIC
BEGIN
	DECLARE old_stock INT;
    DECLARE new_stock INT;
    SELECT `stock` INTO old_stock FROM `product` WHERE id_product = productID;
    SET new_stock = old_stock - quantity;
    IF new_stock >=0  
		THEN UPDATE `product` SET stock = new_stock WHERE id_product = productID;
		ELSE RETURN 'ERROR: La cantidad a decrementar supera a la cantidad de producto en stock.';
    END IF;
    RETURN CONCAT('CONFIRMADO: El producto con ID: ', productID, ', fue reducido en: ', quantity, '. Stock remanente: ', (SELECT `stock` FROM `product` WHERE id_product = productID));
END
$$
DELIMITER ;

#SELECT * FROM product;
#SELECT decrease_stock(5, 2);

#FUNCTION 5
DELIMITER $$
CREATE FUNCTION `top_purchase` () RETURNS VARCHAR(100)
# Esta función me retorna el usuario que realizó la compra mas valiosa, y el valor de la misma. 
DETERMINISTIC
BEGIN
	DECLARE maxPurchase FLOAT;
    DECLARE mostValuableUser VARCHAR(30);
    SELECT MAX(total_price) INTO maxPurchase FROM `purchase_order`;
    SELECT u.username INTO mostValuableUser FROM `purchase_order` po 
	JOIN `user` u ON po.user_id = u.id_user
	WHERE total_price = maxPurchase;
    RETURN CONCAT('La compra TOP fue del usuario: "', mostValuableUser, '", por un precio total de: $', maxPurchase, '.');
END
$$
DELIMITER ;

#SELECT top_purchase();


# STORED PROCEDURES 


#SP 1 ----------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS sp_order_product_table_by//
/*Este Stored Procedure permite ordenar la tabla de productos (product) ingresando por parámetro primero la columna por la que se quiera ordenar,
y segundo la forma (ascendente o descendente). El primer parámetro ingresado (columna a ordenar) se fuerza a lowercase a traver de la función LOWER().*/
CREATE PROCEDURE `sp_order_product_table_by` (IN input_field VARCHAR(30), IN criteria CHAR(4))
BEGIN
	SET @field = LOWER(input_field);
	IF @field != '' THEN
		SET @field_selected = concat('ORDER BY ', @field);
	ELSE	
		SET @field_selected = '';
	END IF;
        
	IF criteria IN ('asc','ASC','DESC','desc') THEN
		SET @criteria_selected = criteria;
	ELSE
		SET @criteria_selected = '';
	END IF;
 
 SET @clausula = concat('SELECT * FROM product ', @field_selected, ' ', @criteria_selected);
 PREPARE runSQL FROM @clausula;
 EXECUTE runSQL;
 DEALLOCATE PREPARE runSQL;
END
//
DELIMITER ;

#LLAMADOS DE PRUEBA
#CALL sp_order_product_table_by('STOCK', 'asc');
#CALL sp_order_product_table_by('name', 'desc');
#CALL sp_order_product_table_by('name', 'asc');


#SP 2 ---------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `sp_add_new_product`//
CREATE PROCEDURE `sp_add_new_product` (IN new_product VARCHAR(50), IN new_price INT, IN new_stock INT, IN variedad VARCHAR(20), IN categoria VARCHAR (20))
/* Este SP permite agregar un nuevo producto a la tabla product. En los parámetros de ingreso, la categoría y la variedad se agregan como string y son convertidos automáticamente
en su respectivo valor de Foreing Key (FK). */
BEGIN
	SET @product_name = concat("'", new_product, "'");
    SET @new_price = new_price;
    IF variedad IN (SELECT category FROM product_category) THEN
		SELECT id_variety INTO @new_variety FROM product_variety WHERE variety = variedad;
	ELSE
		SET @new_variety = 1;
    END IF;
    
    IF categoria IN (SELECT category FROM product_category) THEN
		SELECT id INTO @new_category FROM product_category WHERE category = categoria;
	ELSE
		SET @new_category = 8;
    END IF;
    
    
    SET @parameters_in = concat(@product_name,', ', new_price,', ',new_stock,', ',@new_variety,', ',@new_category);
    
	SET @clausula2 = concat('INSERT INTO product (name, price, stock, variety, category) VALUES (', @parameters_in, ');');
    PREPARE runSQL FROM @clausula2;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL;
END
//
DELIMITER ;

# LLAMADO DE PRUEBA
#CALL sp_add_new_product('test: jabon de limón', 3000, 10, 'limón', 'jabones');
#SELECT * FROM product;

# TRIGGERS

#Creación tabla de auditoría de productos agregados/actualizados
CREATE TABLE `_product_audit` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `id_product` int not null,
  `product_name` varchar(120) not null,
  `date` datetime not null,
  `created_by` varchar(100) not null,
  `last_updated_by` varchar(100) not null,
  `last_update_date` datetime not null,
  PRIMARY KEY (`id_log`)
);

ALTER TABLE _product_audit
ADD CONSTRAINT FK_ProductAudit FOREIGN KEY(`id_product`) REFERENCES `product`(`id_product`);

#EL TRIGGER TR_AUDIT_PRODUCT HARÁ AUDITORIA EN LA TABLA _PRODUCT_AUDIT DESPUÉS DE AGREGARSE UN PRODUCTO A LA TABLA PRODUCT.
CREATE TRIGGER `tr_audit_product`
AFTER INSERT ON `product`
FOR EACH ROW
INSERT INTO `_product_audit` (id_product, product_name, created_by, date, last_updated_by, last_update_date)
VALUES (NEW.id_product, NEW.name, user(), current_timestamp(), user(), current_timestamp());  
  
#INSERT INTO `product` (`name`, `price`, `stock`, `variety`, `category`, `discount`) VALUES ('canasta de mimbre', 5000, 5, 1, 1, 1);

# EL TRIGGER TR_AUDIT_PRODUCT_UPDATE SE DISPARA CUANDO HAY ALGUN UPDATE EN LA TABLA PRODUCT, Y ACCIONA ACTUALIZANDO EN LA TABLA DE AUDITORIA QUIEN Y CUANDO REALIZO LA ÚLTIMA ACTUALIZACIÓN.
CREATE TRIGGER `tr_audit_product_update`
AFTER UPDATE ON `product`
FOR EACH ROW
UPDATE `_product_audit` SET last_updated_by = user(), last_update_date = current_timestamp()
WHERE id_product = OLD.id_product;

#UPDATE product SET name = 'canasta de plástico' WHERE id_product = 29;

#VERIFICAR FUNCIONAMIENTO: 
#SELECT * FROM product; 
#SELECT * FROM _product_audit; 

# TABLA USER AUDIT DONDE SE PODRA VER EL USERNAME Y EMAIL DE LOS USUARIOS REGISTRADOS/BORRADOS ASI COMO LA FECHA DONDE CAMBIO SU ESTADO.
CREATE TABLE `_user_audit` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `action` varchar(15) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id_log`)
);

#TRIGGER TR_USER_AUDIT_SIGNED QUE REGISTRA EN LA TABLA USER AUDIT EL USERNAME, EMAIL DEL USUARIO Y FECHA DEL CLIENTE QUE SE REGISTRA, DESPUÉS DEL INSERTARSE EN LA TABLA.
CREATE TRIGGER `tr_user_audit_signed`
AFTER INSERT ON `user`
FOR EACH ROW
INSERT INTO `_user_audit` (username, email, action, date)
VALUES (NEW.username, NEW.email, 'registrado', current_timestamp());

#INSERT INTO `user` (`username`, `login_password`, `email`, `first_name`, `last_name`, `address`, `location`) VALUES ('test.user', 'fakepassword123', 'email@test.com', 'Diego', 'Test', 'Calle falsa 123', 1);

#TRIGGER TR_USER_AUDIT_DELETED QUE REGISTRA EN LA TABLA USER AUDIT EL USERNAME, EMAIL DEL USUARIO Y FECHA DEL CLIENTE QUE SE ELIMINA, ANTES DEL DELETE EN LA TABLA USUARIO.
CREATE TRIGGER `tr_user_audit_deleted`
BEFORE DELETE ON `user`
FOR EACH ROW
INSERT INTO `_user_audit` (username, email, action, date)
VALUES (OLD.username, OLD.email, 'eliminado', current_timestamp());

#DELETE FROM `user` WHERE email = 'email@test.com';

#VERIFICAR FUNCIONAMIENTO: 
#SELECT * FROM user;
#SELECT * FROM _user_audit;

# DCL ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE mysql;
SHOW tables;
SHOW VARIABLES LIKE 'validate_password%';

SELECT * FROM `user`;

# CREATE USER crea el usuario user1@localhost y user2@localhost, con sus respectivas passwords.
CREATE USER user1@localhost IDENTIFIED BY 'easyPassword1#';
CREATE USER user2@localhost IDENTIFIED BY 'easyPassword2#';
#DROP USER user1@localhost;
#DROP USER user2@localhost;

GRANT SELECT ON ecommerce_db.* TO user1@localhost; # Da permisos de SELECT (leer) al usuario user1, en todas las tablas (*) del esquema ecommerce_project_ruiz.
GRANT SELECT, UPDATE, INSERT ON ecommerce_db.* TO user2@localhost; # Da permisos de SELECT (leer), UPDATE (modificar) y INSERT (insertar) al usuario user2, en todas las tablas (*) del esquema ecommerce_project_ruiz.

SHOW GRANTS FOR user1@localhost;
SHOW GRANTS FOR user2@localhost;

# TCL -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE ecommerce_db;

#Desactivamos el autocommit
SELECT @@AUTOCOMMIT;
SET AUTOCOMMIT = 0;

SELECT * FROM `product`;

#Comenzamos la primer transacción
START TRANSACTION;
#Agregamos 3 productos nuevos con el Stored Procedure:
CALL sp_add_new_product('perfume', 2000, 12, 'limón', 'splash');
CALL sp_add_new_product('fragancia', 3000, 17, 'eucalípto', 'velas');
CALL sp_add_new_product('aroma', 4000, 18, 'jazmín', 'aromatizadores');

#ROLLBACK; #Descomentar para deshacer cambios.
#COMMIT; #Descomentar para efectivizar cambios.

# ************************************************** SEGUNDA TRANSACTION *****************************************************

START TRANSACTION;

SELECT * FROM `location`;

INSERT INTO `location` (`name`) VALUES
('Chile'),
('Brasil'),
('Uruguay'),
('Paraguay');
SAVEPOINT first_block_checkpoint;
INSERT INTO `location` (`name`) VALUES
('Estados Unidos'),
('Canada'),
('Italia'),
('España');
SAVEPOINT second_block_checkpoint;

#RELEASE SAVEPOINT first_block_checkpoint; #Descomentar para borrar el primer savepoint.

#ROLLBACK; #Descomentar para deshacer cambios.
#COMMIT; #Descomentar para efectivizar cambios.

SELECT @@AUTOCOMMIT;
SET AUTOCOMMIT = 1;