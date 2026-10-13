# Conferência antes de enviar o aviso (0.4.0)

1. CI do commit publicado verde: https://github.com/marizada86/nottgard-survivor/actions (run do `602cef5`, "Build and Release").
2. O release `latest` mostra **Playtest v0.4.0 (602cef5…)** com `NottgardSurvivors-windows.zip` e `NottgardSurvivors.exe`
   (https://github.com/marizada86/nottgard-survivor/releases/tag/latest). Se ainda mostrar `ce2d259`, o CI não terminou.
3. Baixe o zip, extraia numa pasta nova, abra o `.exe` e confira o rodapé do menu: **0.4.0**.
4. Jogue 2 minutos: Esc abre as abas Jogo/Catálogo/Configurações; a barra fina aparece sob o relógio; quests no canto direito.
5. Anexe os 3 PDFs e cole o texto de `AVISO-DISCORD.md`.
6. Se o webhook `DISCORD_WEBHOOK_DOWNLOADS` estiver configurado no GitHub, o próprio CI já avisou o link no Discord a cada push; o aviso com os PDFs é o seu.
