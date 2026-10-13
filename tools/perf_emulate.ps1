<#
 PLAN-099 (SPEC-172): emula uma maquina fraca para a sonda de desempenho (tools/perf_probe).
 Limita o jogo a N nucleos, baixa a prioridade e, opcionalmente, coloca queimadores de CPU nos mesmos nucleos
 (cada queimador a mais divide o nucleo: 1 queimador = ~2x mais lento, 3 = ~4x).
 LIMITE: emula CPU. NAO emula GPU, VRAM, disco nem a velocidade de um processador antigo (cache, IPC).
 Os numeros servem para estimar o fator de folga, nao para prever uma maquina especifica.

 Uso:
   powershell -ExecutionPolicy Bypass -File tools/perf_emulate.ps1 -Modo sim   -Niveis "0,1,3" -Fases molor,shedaklah -Segundos 90
   powershell -ExecutionPolicy Bypass -File tools/perf_emulate.ps1 -Modo scene -Niveis "0,1,3" -Fases molor -Quadros 600
 Saida: uma linha por nivel (queimadores) e fase, e o arquivo bruto em .atena/generated/plan-099/.
#>
param(
	[ValidateSet("sim", "scene")] [string]$Modo = "sim",
	[string]$Niveis = "0,1,3",   # lista separada por virgula (com -File o PowerShell nao monta o array)
	[string[]]$Fases = @("molor", "shedaklah"),
	[int]$Segundos = 90,
	[int]$Quadros = 600,
	[int]$Nucleos = 1,
	[int]$Semente = 7,
	[string]$Heroi = "durvall",
	[switch]$SemLimite   # roda tambem sem afinidade, como linha de base
)
$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent $PSScriptRoot
$godot = Join-Path $raiz "Godot_v4.7.2-stable_win64.exe"
if (-not (Test-Path $godot)) { throw "Godot nao encontrado em $godot" }
$saida = Join-Path $raiz ".atena/generated/plan-099"
New-Item -ItemType Directory -Force $saida | Out-Null

$total = [Environment]::ProcessorCount
if ($Nucleos -ge $total) { throw "Use menos nucleos ($Nucleos) que os da maquina ($total) para sobrar um para os queimadores e o sistema" }
$mascara = [IntPtr]([int64]((1 -shl $Nucleos) - 1) -shl 0)   # nucleos 0..N-1

function Iniciar-Queimadores($quantos, $mascara) {
	$lista = @()
	for ($i = 0; $i -lt $quantos; $i++) {
		$p = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile", "-Command", "while (`$true) { `$x = 1 }" -PassThru -WindowStyle Hidden
		$p.ProcessorAffinity = $mascara
		$p.PriorityClass = "BelowNormal"
		$lista += $p
	}
	return $lista
}

function Rodar($rotulo, $limitar, $queimadores) {
	$bruto = Join-Path $saida ("{0}-{1}.log" -f $Modo, $rotulo)
	$args = @("--path", $raiz, "res://tools/perf_probe.tscn")
	if ($Modo -eq "sim") { $args = @("--headless") + $args }
	$args += @("--", $Modo, $(if ($Modo -eq "sim") { $Segundos } else { $Quadros }), $Semente, $Heroi, ($Fases -join ","))
	$burn = @()
	if ($limitar -and $queimadores -gt 0) { $burn = Iniciar-Queimadores $queimadores $mascara }
	try {
		$relogio = [Diagnostics.Stopwatch]::StartNew()
		$p = Start-Process -FilePath $godot -ArgumentList $args -PassThru -RedirectStandardOutput $bruto -RedirectStandardError ($bruto + ".err") -WindowStyle $(if ($Modo -eq "sim") { "Minimized" } else { "Normal" })
		if ($limitar) {
			$p.ProcessorAffinity = $mascara
			$p.PriorityClass = "BelowNormal"
		}
		$p.WaitForExit()
		$relogio.Stop()
	}
	finally {
		foreach ($b in $burn) { if (-not $b.HasExited) { $b.Kill() } }
	}
	$linhas = Get-Content $bruto | Where-Object { $_ -match "^PROBE;" }
	foreach ($l in $linhas) {
		if ($Modo -eq "sim" -and $l -match "fase=(\w+);passos=(\d+);.*us_passo_medio=([\d.]+);us_p95=(\d+);us_max=(\d+);.*replica_fiel=(\w+)") {
			"{0,-14} {1,-12} passos={2} us/passo={3} p95={4} max={5} fiel={6}" -f $rotulo, $Matches[1], $Matches[2], $Matches[3], $Matches[4], $Matches[5], $Matches[6]
		}
		elseif ($Modo -eq "scene" -and $l -match "cena=(\w+);quadros=(\d+);ms_medio=([\d.]+);ms_p95=([\d.]+);ms_max=([\d.]+);inimigos_max=(\d+);.*draw_calls=(\d+)") {
			"{0,-14} {1,-12} quadros={2} ms_medio={3} p95={4} max={5} inimigos={6} draws={7}" -f $rotulo, $Matches[1], $Matches[2], $Matches[3], $Matches[4], $Matches[5], $Matches[6], $Matches[7]
		}
	}
	"{0,-14} parede={1:N0}s (arquivo: {2})" -f $rotulo, $relogio.Elapsed.TotalSeconds, (Split-Path -Leaf $bruto)
}

if ($SemLimite) { Rodar "livre" $false 0 }
foreach ($n in ($Niveis -split "[,;s]+" | Where-Object { $_ -ne "" } | ForEach-Object { [int]$_ })) {
	Rodar ("{0}nuc+{1}queim" -f $Nucleos, $n) $true $n
}
