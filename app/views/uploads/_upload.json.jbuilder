json.extract! upload, :id, :dir, :pfad, :inhalt, :created_at, :updated_at
json.url upload_url(upload, format: :json)
