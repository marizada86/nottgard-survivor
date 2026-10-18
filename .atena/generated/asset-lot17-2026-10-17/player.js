'use strict';
const sequences = window.SEQUENCES;
const notes = {"SW":"Espada na mao anatomica esquerda proposta, contato oposto emSW03. Conferir SW04 e retorno; registro/escala/cadencia pendentes."};
const root = document.getElementById('players');
window.LOT17_PLAYERS = [];
for (const sequence of sequences.filter(s => s.frame_count > 1)) {
  const card = document.createElement('article'); card.className = 'card'; card.dataset.code = sequence.code;
  const heading = document.createElement('h2'); heading.textContent = `${sequence.code} ${sequence.revision} — ${sequence.name}`; card.append(heading);
  const status = document.createElement('p'); status.className = 'status'; status.textContent = `${sequence.frame_count} quadros · ${sequence.width}×${sequence.height} · fontes individuais · DRAFT`; card.append(status);
  const image = document.createElement('img'); image.className = 'player'; image.style.objectFit='contain'; image.alt = `Prévia ${sequence.code}, quadro 1`; image.src = sequence.frames[0].qa_frame; card.append(image);
  const controls = document.createElement('div'); controls.className = 'controls';
  const toggle = document.createElement('button'); toggle.textContent = 'Pausar'; toggle.type = 'button';
  const replay = document.createElement('button'); replay.textContent = 'Reiniciar'; replay.type = 'button';
  const fps = document.createElement('select'); fps.setAttribute('aria-label', `Velocidade ${sequence.code}`);
  for (const value of [2,5,10,12]) { const option = document.createElement('option'); option.value = value; option.textContent = `${value} FPS`; option.selected = value === 5; fps.append(option); }
  const loopLabel = document.createElement('label'); const loop = document.createElement('input'); loop.type = 'checkbox'; loop.checked = sequence.loop; loopLabel.append(loop, document.createTextNode(' Repetir'));
  controls.append(toggle,replay,fps,loopLabel); card.append(controls);
  const slider = document.createElement('input'); slider.type = 'range'; slider.min = 0; slider.max = sequence.frame_count-1; slider.value=0; slider.setAttribute('aria-label', `Quadro ${sequence.code}`); slider.style.width='100%'; card.append(slider);
  const counter = document.createElement('p'); counter.className = 'status'; card.append(counter);
  const warning = document.createElement('p'); warning.className = 'warn'; warning.textContent = notes[sequence.code] + ` Alfa e preparação final pendentes; base do contorno: ${sequence.core_base_spread_px} px.`; card.append(warning);
  const link = document.createElement('a');
  link.href = sequence.frames[0].source_link; link.textContent='Primeira fonte original'; card.append(link);
  const details = document.createElement('details'); const summary = document.createElement('summary'); summary.textContent='Ver todos os quadros'; details.append(summary); const contact=document.createElement('img'); contact.className='contact'; contact.src=`${sequence.code}-contact.png`; contact.alt=`Contato dos quadros ${sequence.code}`; details.append(contact); card.append(details);
  const state = {code:sequence.code,index:0,playing:true,errors:0,draws:0};
  const draw = () => { image.src=sequence.frames[state.index].qa_frame; image.alt=`Prévia ${sequence.code}, quadro ${state.index+1}`; slider.value=state.index; counter.textContent=`Quadro ${state.index+1}/${sequence.frame_count}`; state.draws++; };
  image.addEventListener('error', () => { state.errors++; counter.textContent='Falha ao carregar a célula de QA.'; });
  const pause = () => { state.playing=false; toggle.textContent='Reproduzir'; };
  toggle.addEventListener('click', () => { if(state.playing) pause(); else { if(state.index===sequence.frame_count-1)state.index=0; state.playing=true;toggle.textContent='Pausar';draw(); } });
  replay.addEventListener('click', () => {state.index=0;state.playing=true;toggle.textContent='Pausar';draw();});
  slider.addEventListener('input', () => {state.index=Number(slider.value);pause();draw();});
  let previous=performance.now();
  const tick = now => { if(now-previous >= 1000/Number(fps.value)) {previous=now;if(state.playing){if(state.index<sequence.frame_count-1)state.index++;else if(loop.checked)state.index=0;else pause();draw();}} requestAnimationFrame(tick); };
  const sources=document.createElement('p'); for(const f of sequence.frames){const a=document.createElement('a');a.href=f.source_link;a.textContent=f.code+' '+f.revision+' ';sources.append(a);}card.append(sources);
  draw(); root.append(card); window.LOT17_PLAYERS.push(state); requestAnimationFrame(tick);
}
