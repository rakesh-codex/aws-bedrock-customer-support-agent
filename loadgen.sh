#!/bin/bash
TOKEN="eyJraWQiOiJjSnhXUlhOY0VPak1JRFNlZ2Y2SVMrVFUvaFA5VEthMTdkQVBPM1RnekdzPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI0NGQ4ODRmOC0xMGExLTcwNTItYzUxZC04MWU0YzFmOWVmMDEiLCJpc3MiOiJodHRwczovL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL3VzLWVhc3QtMV9wTGJubUxBcmkiLCJjbGllbnRfaWQiOiIxbGI3aWp2bDhuM3V1ZnJ0bGVuMXJxOXI2cyIsIm9yaWdpbl9qdGkiOiIxODFjOWNjZi1kZTRhLTQ1NjMtOThiZS0zNmVlZDRlMjRkYWEiLCJldmVudF9pZCI6IjhmNjdjMTk3LWM1ZjQtNDRlOS1iYmFiLTY4ZjBkOWQ0NWE3MSIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3ODc0OTYyODMsImV4cCI6MTc4NzQ5OTg4MywiaWF0IjoxNzg3NDk2MjgzLCJqdGkiOiIxYmJmMjFjYS0xMWQ3LTQxOTAtYjBiZS05OGQwY2EyNjNhMTciLCJ1c2VybmFtZSI6IjQ0ZDg4NGY4LTEwYTEtNzA1Mi1jNTFkLTgxZTRjMWY5ZWYwMSJ9.lx5CG6xhueca4tjIvEAwczcMnqfrH9N9CfwZc19W_cnNpzX2xbqz09Rez2Y4Vvnb0R6br2VZl3neHjRFqKOMUmdIfRZz1dfRhGsuR1mpsUx_7gMtrXD_AXy9OOFTUJ7LXvVWxbu18A7WnaZcSwAFGu9hrbFUFAXkOphGh1ju91yqBN-B1dzTfyIqFnhfn2maf3FK_5osMHuWPrbbHCfKrk6B2vhBN03Qn-fHCL4C5JiNSA0THEB_fBkVqiOme9qRpzXhLJSCY_opg6g4Tyk0huUS_n3dIH9drnYEe-9kwpf3Wgh52EERHubedkNVO5Kn2sK3lv8kNVLV0QVPNnRtXA"
GATEWAY_URL="https://customersupport-my-gateway-secure-pbpv29zw5u.gateway.bedrock-agentcore.us-east-1.amazonaws.com/customer-support-ab/invocations"

PROMPTS=(
  "What's the price of the Smart Watch?"
  "My headphones are broken, what should I do?"
  "Is PROD-002 still under warranty?"
  "What's the return policy for audio products?"
  "It stopped working. Can I get a refund?"
  "I want to return my USB-C Hub and check its warranty."
)

for i in $(seq 1 30); do
  PROMPT="${PROMPTS[$(( (i - 1) % ${#PROMPTS[@]} ))]}"
  SESSION_ID=$(python3 -c "import uuid; print(str(uuid.uuid4()) + '-' + str(uuid.uuid4())[:8])")
  echo "=== Request $i: $PROMPT ==="
  curl -s \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "X-Amzn-Bedrock-AgentCore-Runtime-Session-Id: $SESSION_ID" \
    -d "{\"prompt\": \"$PROMPT\"}" \
    -X POST "$GATEWAY_URL"
  echo ""
  sleep 2
done
