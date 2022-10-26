create database sqltrabajo;
use sqltrabajo;

-- Creacion de tablas

create table Consumidores (
id int not null auto_increment PRIMARY KEY,
nombre varchar (255) NOT NULL,
apellido varchar (255) NOT NULL,
direccion varchar (255) NOT NULL
);

create table Aplicacion (
id int not null,
pedido_descripcion varchar (255) NOT NULL,
forma_pago int PRIMARY KEY,
pedidoID int,
FOREIGN KEY (pedidoID)
REFERENCES Consumidores (id)
);

create table Forma_de_pago (
id int,
tipo_pago varchar (55),
FOREIGN KEY (id)
REFERENCES Aplicacion (forma_pago)
);

create table Restaurante (
Id int,
nombrer varchar (255),
producto int PRIMARY KEY,
FOREIGN KEY (id)
REFERENCES Consumidores (id)
);

create table Productos (
id int,
tipo varchar (255),
precio int,
tipo_delivery int PRIMARY KEY,
FOREIGN KEY (id)
REFERENCES Restaurante (producto)
);

create table Delivery (
id int,
tipo varchar (255),
FOREIGN KEY (id)
REFERENCES Productos (tipo_delivery)
);

-- INSERTS --

insert into Consumidores (Id, Nombre, Apellido, Direccion) values (1, 'franco', 'gonzalez', 'derqui');
insert into Consumidores (Id, Nombre, Apellido, Direccion) values (2, 'juan', 'perez', 'francia');
insert into Consumidores (Id, Nombre, Apellido, Direccion) values (3, 'maria', 'serrano', 'florida');

insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (1, 'comida', 3, 3);
insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (2, 'helado', 1, 1);
insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (3, 'perfmueria', 4, 2);

insert into Forma_De_Pago (id, tipo_pago) values (1, 'debito');
insert into Forma_De_Pago (id, tipo_pago) values (3, 'efectivo');
insert into Forma_De_Pago (id, tipo_pago) values (4, 'transferencia');

insert into Restaurante (id, NombreR, Producto) values (1, 'antares', '2');
insert into Restaurante (id, NombreR, Producto) values (2, 'gluck', '3');
insert into Restaurante (id, NombreR, Producto) values (3, 'farmacia', '4');

insert into Productos (id, Tipo, Precio, Tipo_delivery) values (1, 'bebidas', 100, 1);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (2, 'comida', 150, 2);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (3, 'helado', 200, 3);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (4, 'perfmueria', 120, 4);

insert into Delivery (id, tipo) values (1, 'moto');
insert into Delivery (id, tipo) values (2, 'auto');
insert into Delivery (id, tipo) values (3, 'bicicleta');
insert into Delivery (id, tipo) values (4, 'retiro');

-- Creacion vistas

create view precios as
select precio from productos;

create view deliverys as
select tipo from Delivery;

create view tiposproductos as
select tipo from Productos;

create view nombresrestaurantes as
select NombreR from Restaurante;

create view pagos as
select tipo_pago from Forma_De_Pago;

-- Funciones almacenadas

-- El objetivo de la primera funcion es saber los medios de pago que acepta la aplicacion

delimiter //

create function tipopagos() returns varchar(45)
deterministic
begin
return 'efectivo,debito,credito';
end //;

select tipopagos();

-- El objetivo de la segunda funcion es saber el costo de una cena total en base a los precios dados en el set de datos, 
-- contando la comida, bebidas y helado. (Suma las 3)

delimiter //

create function totalcenas (comida int, bebidas int, helado int) returns int
deterministic
begin
declare costototal int;
set costototal= ((comida)+(bebidas)+(helado));
return costototal;
end //;

select totalcenas (100,150,200);

DELIMITER //
create procedure ordenar (orden varchar(255))
SELECT Precio from Productos
ORDER by CASE WHEN orden='ASC' THEN Precio END asc,
         CASE WHEN orden='DESC' THEN Precio END desc;
end;
//

call ordenar ('ASC');

-- Este S.P permite ordenar en orden ascendente o descendente (dependiendo el parametro 'ASC' o 'DESC') la lista de precios de la tabla productos. --

DELIMITER //
create procedure insertar (tipo varchar (55))
BEGIN
insert into Forma_De_Pago (tipo_pago) values (tipo);
END;
//

call insertar ('MercadoPago');
select * from Forma_De_Pago;

-- Este S.P permite agregar métodos de pago dentro de la columna tipo_pago

- TRIGGERS --


create table ConsumidoresLog (
id int not null auto_increment PRIMARY KEY,
nombre varchar (255) NOT NULL,
apellido varchar (255) NOT NULL,
direccion varchar (255) NOT NULL,
fecha varchar (255),
hora varchar (55),
usuario varchar (55)
);

create table DeliveryLog (id int,
tipo varchar (255),
fecha varchar (55),
hora varchar (255),
usuario varchar (55),
FOREIGN KEY (id)
REFERENCES Productos (tipo_delivery)
);

create table deliverybackup 
(id int,
tipo varchar (255),
fecha varchar (55),
hora varchar (255),
usuario varchar (55),
FOREIGN KEY (id)
REFERENCES Productos (tipo_delivery)
);

-- En el primer trigger, se realizó una tabla bitácora donde los datos insertados en la tabla consumidores se reflejen también en la tabla consumidoreslog

create trigger copia_datos 
after insert on Consumidores
for each row
insert into ConsumidoresLog (nombre, apellido, direccion) values (new.nombre, new.apellido, new.direccion);

-- En el segunddo trigger, se indica la fecha, hora y el usuario que modifica la tabla o campo. Esta aparecera en la columna correspondiente de la tabla consumidoreslog.

create trigger fecha_modificacion
before insert on Consumidores
for each row
insert into ConsumidoresLog (fecha, hora, usuario) values (date, time, user)

-- En el tercer trigger, se indica la fecha, hora y el usuario que modifica la tabla o campo. Esta aparecera en la columna correspondiente de la tabla deliverylog.

create trigger copia_datosDel
after insert on Delivery
for each row
insert into DeliveryLog (tipo, fecha, hora, usuario) values (new.tipo, date, time, user);

-- En el cuarto trigger, cada vez que un usuario intente borrar algo de la tabla delivery, se hara un backup automaticamente dentro de la tabla backup_del.

DELIMITER //
create trigger backup_del
before delete on delivery
for each row
begin
insert into deliverybackup (tipo, fecha, hora, usuario) values (old.tipo, date, time, user);
end
//
















