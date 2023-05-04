create database Transaccion;
-------
create table transaccion.inventario(
	id_producto int not null primary key,
    nombre_producto varchar(45) not null);
--------    
create table transaccion.productos(
	id int not null primary key,
    id_producto int not null,
    cantidad int unsigned,
    foreign key(id_producto) references inventario(id_producto));
 -------
 create table transaccion.factura(
	num_factura int auto_increment primary key,
    total_productos int,
    producto_agregado int,
    descuento_producto int,
    fecha datetime,
    foreign key (total_productos) references productos(id),
    foreign key (producto_agregado) references productos(id));
-------
insert into inventario(id_producto,nombre_producto) values (1,'Arroz');
insert into inventario(id_producto,nombre_producto) values (2,'Azucar');


insert into productos(id,id_producto,cantidad) values (5,1,20);
insert into productos(id,id_producto,cantidad) values (6,2,10);

-------

DELIMITER //
create procedure Transferenciainventario(
	in totalproductos int,
    in productoagregado int,
    in descuentoproducto int)
begin
    declare exit handler for 1690
    begin
		select 'Producto Agotado';
        rollback;
	end;
    start transaction;
    update productos set cantidad = cantidad - descuentoproducto where id = totalproductos;
    update productos set cantidad = cantidad + descuentoproducto where id = productoagregado;
    insert into factura(total_productos, producto_agregado, descuento_producto,fecha) 
    values (totalproductos, productoagregado, descuentoproducto,now());
	commit;

end;
//
call Transferenciainventario(5,6,10); 
call transferenciainventario(6,5,5);
call transferenciainventario(6,5,50);   
   
select * from productos;
select * from factura;