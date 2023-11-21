class Vikingo{
	var property casta = jarl
	
	method esProductivo()
	method subirExpedicion() = self.esProductivo() and casta.puedeIrExpedicion(self)
	method escalarSocialmente() = casta.escalarSocialmente(self)
	method bonificarAscenso()
}

class Granjero inherits Vikingo{
	var property hijos
	var property hectareas
	
	override method esProductivo() = hectareas/hijos >= 2
	override method bonificarAscenso(){hijos+=2 hectareas+=2}
}

class Soldado inherits Vikingo{
	var property vidasCobradas
	var property armas
	
	method tieneArmas()= self.armas()>0
	override method esProductivo() = vidasCobradas>20 and self.tieneArmas()
	override method bonificarAscenso(){armas+=10}
}

//--------------- clases sociales

class Casta{
	method puedeIrExpedicion(vikingo)= true	
}

object jarl inherits Casta{
	override method puedeIrExpedicion(vikingo)= not vikingo.tieneArmas()
	method escalarSocialmente(vikingo){
		vikingo.casta(karl) 
		vikingo.bonificarAscenso()
	}
}

object karl inherits Casta{
	method escalarSocialmente(vikingo)= vikingo.casta(thrall)
}

object thrall inherits Casta{
	method escalarSocialmente(vikingo) {}
}

//--------------- expediCiones
class Expedicion{
	var property destinos = []
	var property integrantes = []
	
	method agregarDestino(destino) = destinos.add(destino)
	method loVale()= destinos.all{destino => destino.valeLaPena(integrantes.size())}
	
}	

//--------------- lugares para expedicionar 

class Lugar{
	method valeLaPena(cantIntegrantes)
	method botin(cantIntegrantes)
}


class Capital inherits Lugar{	
	var property riqueza
	var property defensores
	
	override method valeLaPena(cantIntegrantes) = self.botin(cantIntegrantes)/cantIntegrantes>=3
	override method botin(cantIntegrantes) {
		return if(cantIntegrantes>defensores) defensores*riqueza
		else return 0
	}
}


class Aldea inherits Lugar{
	var property crucifijos
	
	override method valeLaPena(cantIntegrantes) = self.botin(cantIntegrantes)>15
	override method botin(cantIntegrantes)=crucifijos
}

class AldeaAmurallada inherits Aldea{
	var property vikingosMinimos
	override method valeLaPena(cantIntegrantes) = cantIntegrantes>vikingosMinimos
}

