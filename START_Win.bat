@echo off

REM Start backend

echo Starting backend server...
cd UNISAT_BACK

REM Install backend dependencies
if exist node_modules (
    echo Backend dependencies are already installed.
) else (
    echo Installing backend dependencies...
    call npm install
)

REM Start backend server in a new window
start cmd /k "npm start"

cd ..

REM Start frontend

echo Starting frontend server...
cd UNISAT_FRONT

REM Install frontend dependencies
if exist node_modules (
    echo Frontend dependencies are already installed.
) else (
    echo Installing frontend dependencies...
    call npm install
)

REM Start frontend server in a new window
start cmd /k "npm start"

cd ..

echo Project successfully started. Opening browser...

REM Wait a few seconds to allow servers to start
timeout /t 10 /nobreak > NUL

REM Open the browser with your site
start http://localhost:4200

echo Done!
