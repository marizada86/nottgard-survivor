import json
import pathlib
import subprocess

out = pathlib.Path(__file__).resolve().parent
root = out.parents[2]
published = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
assert published == '2a5873a08ee1681990ae7ac603fdb2256ef7e0a1'
state_path = root / '.atena/state/assets-main-publication.yaml'
state = state_path.read_text(encoding='utf-8').replace('status: VALIDATED_READY_FOR_MAIN_PUSH', 'status: COMPLETE_PUBLISHED').replace('checkpoint: G-003/MAIN_FF_AND_PUSH', 'checkpoint: COMPLETE').replace('completed_steps: 2', 'completed_steps: 3').replace('next_objective: Commitar grupos autorizados e verificar checkout limpo antes de publicar.', 'next_objective: Retomar fila autorizada; feedback humano dos playtests permanece pendente.')
state += f'\nverified_runtime_push_sha: {published}\npublication_receipt: this_commit\nfinal_remote_sha_receipt: .atena/generated/assets-main-publication-2026-10-13/final-machine-receipt.json\nci_result: NOT_VERIFIED\n'
state_path.write_text(state, encoding='utf-8')
central = root / '.atena/state/plan.yaml'
prefix, block = central.read_text(encoding='utf-8').split('assets_main_publication_2026_10_13:', 1)
block = block.replace('status: VALIDATED_READY_FOR_MAIN_PUSH', 'status: COMPLETE_PUBLISHED').replace('checkpoint: G-003/MAIN_FF_AND_PUSH', 'checkpoint: COMPLETE')
block += f'  verified_runtime_push_sha: {published}\n  evidence: .atena/evidence/assets-main-publication-2026-10-13.md\n  completed_steps: 3\n  total_steps: 3\n  ci_result: NOT_VERIFIED\n'
central.write_text(prefix + 'assets_main_publication_2026_10_13:' + block, encoding='utf-8')
evidence = root / '.atena/evidence/assets-main-publication-2026-10-13.md'
with evidence.open('a', encoding='utf-8') as f:
    f.write(f'\nG-003 concluído: integração fast-forward `2ae8c48..{published[:7]}` na main limpa e push normal confirmado. `git ls-remote origin refs/heads/main` retornou `{published}`. Este commit contém apenas o recibo final/estado ADD e será também enviado à main; hash final exato mantido no recibo operacional local ignorado para evitar referência circular. Logs brutos preservam espaços de progresso do Godot (exceção documental, sem alteração de código). CI: conclusão não verificada. Publicação 3/3 concluída, retorno operacional e pendências humanas preservados.\n')
plan_path = out / 'plan.json'
plan = json.loads(plan_path.read_text(encoding='utf-8-sig'))
plan.update(status='COMPLETE_PUBLISHED', verified_runtime_push_sha=published, final_receipt='this_commit', ci_result='NOT_VERIFIED')
plan['commits'] = subprocess.check_output(['git', 'log', '--format=%H %s', f"{plan['base']}..HEAD"], cwd=root, text=True).splitlines()
plan_path.write_text(json.dumps(plan, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Published runtime SHA recorded; final documentation receipt ready')
