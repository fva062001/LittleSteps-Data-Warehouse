-- Trigger que tengo que terminar maldicion ---
create trigger sel_average on sel
	after insert as
begin
	set nocount on
	Declare
		@sel_average float,
		@self_awareness tinyint,
		@self_management tinyint,
		@social_awareness tinyint,
		@relationship_skills tinyint,
		@R_D_M tinyint;
		select @self_awareness = self_awareness from inserted
		select @self_management = self_management from inserted
		select @social_awareness = social_awareness from inserted
		select @relationship_skills = relationship_skills from inserted
		select @R_D_M = R_D_M from inserted
		select @sel_average = avg(@self_awareness, @self_management, @social_awareness, @relationship_skills, @R_D_M) from inserted
	update sel
	set sel_average = @sel_average where id_sel = (select id_sel from inserted)
end