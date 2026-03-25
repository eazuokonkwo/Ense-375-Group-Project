# SETUP AND LAUNCH GUIDE

## 1. System Requirements
- **Operating System**: Windows/Linux/MacOS
- **Node.js**: Version 14.x or higher
- **npm**: Version 6.x or higher
- **Java**: Version 11 or higher (if applicable)

## 2. Building the Project
1. Clone the repository:
   ```bash
   git clone https://github.com/eazuokonkwo/Ense-375-Group-Project.git
   cd Ense-375-Group-Project
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Build the project:
   ```bash
   npm run build
   ```

## 3. Running All Tests
- To run unit tests:
   ```bash
   npm test
   ```
- For integration tests, ensure the application is built and then run:
   ```bash
   npm run test:integration
   ```

## 4. Launching the Application
- After building the project, launch the application with:
   ```bash
   npm start
   ```
- The application will be available at `http://localhost:3000`.

## 5. Verification Checklist
- [ ] The project builds without errors.
- [ ] All unit tests pass.
- [ ] All integration tests pass.
- [ ] The application launches successfully and is reachable on the web.

## 6. Troubleshooting
- **Error: "Module not found"**: Ensure that all dependencies are installed properly with `npm install`.
- **Error: "Port 3000 is already in use"**: Try changing the port or kill the process using the port.
- **Tests are failing**: Check the errors in the console for details and address them accordingly.

---
For more detailed instructions, consult the specific documentation or README files in the project repository.