{{/* Labels */}}
{{- define "microservices-intro.labels" }}
labels:
    date: {{ now | htmlDate }}
    {{- if .Chart.AppVersion }}
    app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
    {{- end }}
{{- end }}
