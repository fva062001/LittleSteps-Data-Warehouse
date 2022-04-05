select *  from alumno

drop table alumno

--Trigger para crear la matricula de los estudiantes
create trigger matricula_alumno on alumno
after insert
	as
begin
	set nocount on
	Declare @matricula varchar(8)
	set @matricula = '1013' + convert(varchar, cast(RAND()*(9999-1000)+1000 as int))
	--Debemos crear un ciclo en el caso de que la matricula ya exista en el sistema
	if not exists(select * from alumno where matricula = @matricula)
		begin 
			update alumno
			set matricula = @matricula from inserted i where id_alumno = inserted.id_alumno
		end
	else
		begin
			--En el caso de que la matricula ya exista le volvemos a asignar un valor nuevo a la variable de matricula
			set @matricula = '1013' + convert(varchar, cast(RAND()*(9999-1000)+1000 as int))
		end
end