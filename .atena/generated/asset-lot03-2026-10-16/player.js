'use strict';
const sequences = window.SEQUENCES;
const root = document.getElementById('players');
window.LOT03_PLAYERS = [];
const notes = {
  IA01: 'Base varia 22 px no limiar alfa ≥128; moedas tornam-se visíveis apenas nas poses finais. Conferir continuidade do interior ao abrir.',
  IA02: 'Base varia 33 px; conferir posição e geometria dos encaixes/luz durante a abertura.',
  IA03: 'Base varia 1 px; gesto e respiração discretos. Avaliar o retorno do quarto ao primeiro quadro.',
  IA04: 'Base varia 8 px; martelo tem elevação e retorno visíveis. Conferir salto da estação e consistência das mãos.',
  IA05: 'Base varia 2 px; gesto e vapor mudam. Conferir mãos e estabilidade dos pequenos objetos no loop.',
  IA06: 'Base do contorno varia 36 px, incluindo queda/espalhamento do entulho. Célula extra sem alfa ≥16, porém com resíduos alfa 1–15.'
};
for (const sequence of sequences) {
  const card = document.createElement('article'); card.className = 'card'; card.dataset.code = sequence.code;
  const heading = document.createElement('h2'); heading.textContent = `${sequence.code} v01 — ${sequence.name}`; card.append(heading);
  const status = document.createElement('p'); status.className = 'status'; status.textContent = `${sequence.frame_count} quadros · ${sequence.width}×${sequence.height} · células ${sequence.frames[0].cell_xywh[2]}×${sequence.frames[0].cell_xywh[3]} · DRAFT`; card.append(status);
  const image = document.createElement('img'); image.className = 'player'; image.alt = `Prévia ${sequence.code}, quadro 1`; image.src = sequence.frames[0].qa_frame; card.append(image);
  const controls = document.createElement('div'); controls.className = 'controls';
  const toggle = document.createElement('button'); toggle.textContent = 'Pausar'; toggle.type = 'button';
  const replay = document.createElement('button'); replay.textContent = 'Reiniciar'; replay.type = 'button';
  const fps = document.createElement('select'); fps.setAttribute('aria-label', `Velocidade ${sequence.code}`);
  for (const value of [2,4,8,10,12]) { const option = document.createElement('option'); option.value = value; option.textContent = `${value} FPS`; option.selected = value === 8; fps.append(option); }
  const loopLabel = document.createElement('label'); const loop = document.createElement('input'); loop.type = 'checkbox'; loop.checked = sequence.loop; loopLabel.append(loop, document.createTextNode(' Repetir'));
  controls.append(toggle,replay,fps,loopLabel); card.append(controls);
  const slider = document.createElement('input'); slider.type = 'range'; slider.min = 0; slider.max = sequence.frame_count-1; slider.value=0; slider.setAttribute('aria-label', `Quadro ${sequence.code}`); slider.style.width='100%'; card.append(slider);
  const counter = document.createElement('p'); counter.className = 'status'; card.append(counter);
  const warning = document.createElement('p'); warning.className = 'warn'; warning.textContent = notes[sequence.code]; card.append(warning);
  const link = document.createElement('a');
  link.href = `../animation-candidates/asset-lot03/${sequence.code}_v01.png`; link.textContent='Fonte original'; card.append(link);
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
  draw(); root.append(card); window.LOT03_PLAYERS.push(state); requestAnimationFrame(tick);
}
