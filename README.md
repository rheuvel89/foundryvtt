# foundryvtt
Docker container for FoundryVTT

Fixed multiple instances - OK

```
docker run -d --volume foundryvtt:/app/foundryvtt --volume foundrydata:/app/foundrydata -p 30000:30000 --env TIMED_URL="https://foundryvtt.s3.amazonaws.com/releases/...." foundryvtt
```