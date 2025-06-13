#!/bin/bash

# Configs
CONTAINER_NAME="<nome-do-container>"
TELEGRAM_BOT_TOKEN="<token_do_bot>"
TELEGRAM_CHAT_ID="<id_do_chat>"

# Validação das variáveis
if [ -z "$CONTAINER_NAME" ] || [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
  echo "Erro: Variáveis CONTAINER_NAME, TELEGRAM_BOT_TOKEN ou TELEGRAM_CHAT_ID não definidas" >&2
  exit 1
fi

# Loop
whiel true; do
  #Verificar estado do container
  if [ -z "$(docker ps -q -f name=$CONTAINER_NAME)"]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage -d chat_id=$TELEGRAM_CHAT_ID -d text="Alerta: Container $CONTAINER_NAME está parado!")
    if [ "$RESPONSE" != "200" ]; then
      echo "Erro ao enviar alerta de container: HTTP $RESPONSE" >> /var/log/telegram_alerts.log
    fi
  fi

  sleep 5
done
