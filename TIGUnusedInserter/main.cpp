// TIGUnusedInserter
// jwilins
// Allows easy insertion and deletion of unused Impossible Game level editor features (rising/falling blocks and gravity changes)

#include "libImpossiblelevel.hpp"

// Clear input buffer
void clearInput()
{
	char ch = ' ';
	while ((ch = getchar()) != '\n' && ch != EOF);
}

int main()
{
	// Get level.dat path from user
	char filepath[260];
	printf("Enter the path to the level.dat to edit: ");
	fgets(filepath, 260, stdin);
	// Strip out newlines and quotes from read input
	int pathLen = strlen(filepath);
	if (pathLen > 0 && filepath[pathLen - 1] == '\n') {
		filepath[pathLen - 1] = '\0';
		--pathLen;
	}
	if (filepath[pathLen - 1] == '\"') {
		memmove(&filepath[pathLen - 1], &filepath[pathLen], 1);
	}
	if (filepath[0] == '\"') {
		memmove(&filepath[0], &filepath[1], pathLen);
	}

	// Initialize level object with provided level file
	Level theLevel(filepath);
	if (filepath) {
		int choice = 0;
		// Main choice/level-editing loop
		do {
			// Display options and parse entered choice as integer
			printf("\nWhat do you want to do?\n");
			printf("1: Add a gravity change object\n");
			printf("2: Add a rising blocks object (may or may not take effect!)\n");
			printf("3: Add a falling blocks object\n");
			printf("4: Remove a gravity change object\n");
			printf("5: Remove a rising blocks object\n");
			printf("6: Remove a falling blocks object\n");
			printf("Enter your choice (or -1 to save and quit): ");
			int scanResult = scanf("%d", &choice);
			clearInput();

			// If one input successfully retrieved
			if (scanResult == 1) {
				int remIndex = 0;
				// Addition/removal loop based on choice
				while (true) {
					// Add gravity change
					if (choice == 1) {
						// Get desired gravity change X position from user
						// and add the new gravity change object to the list
						// if valid (sorted by X position)
						GravityChange gravChg = { 0, theLevel.getGravityCount() };
						printf("\nEnter the X position of the gravity change (or -1 to stop): ");
						scanResult = scanf("%d", &gravChg.xPos);
						clearInput();
						if (scanResult == 1) {
							if (gravChg.xPos < 0) {
								break;
							}
							theLevel.addGravitySwitchInOrder(gravChg);
							printf("Gravity change added!\n");
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Add rising blocks
					else if (choice == 2) {
						// Get desired rising blocks start/end X positions from user
						// and add the new rising blocks object to the list
						// if valid (sorted by start X position)
						RisingBlocks risBlk = { 0, 0, theLevel.getRisingCount() };
						printf("\nEnter the start X position of the rising blocks (or -1 to stop): ");
						scanResult = scanf("%d", &risBlk.startX);
						clearInput();
						if (scanResult == 1) {
							if (risBlk.startX < 0) {
								break;
							}
							printf("Enter the end X position of the rising blocks (or -1 to stop): ");
							scanResult = scanf("%d", &risBlk.endX);
							clearInput();
							if (scanResult == 1) {
								if (risBlk.endX < 0) {
									break;
								}
								theLevel.addRisingBlocksInOrder(risBlk);
								printf("Rising blocks added!\n");
							}
							else {
								printf("Could not retrieve input!\n");
							}
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Add falling blocks
					else if (choice == 3) {
						// Get desired falling blocks start/end X positions from user
						// and add the new falling blocks object to the list
						// if valid (sorted by start X position)
						FallingBlocks fallBlk = { 0, 0, theLevel.getFallingCount() };
						printf("\nEnter the start X position of the falling blocks (or -1 to stop): ");
						scanResult = scanf("%d", &fallBlk.startX);
						clearInput();
						if (scanResult == 1) {
							if (fallBlk.startX < 0) {
								break;
							}
							printf("Enter the end X position of the falling blocks (or -1 to stop): ");
							scanResult = scanf("%d", &fallBlk.endX);
							if (scanResult == 1) {
								if (fallBlk.endX < 0) {
									break;
								}
								theLevel.addFallingBlocksInOrder(fallBlk);
								printf("Falling blocks added!\n");
							}
							else {
								printf("Could not retrieve input!\n");
							}
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Remove gravity change
					else if (choice == 4) {
						// Display all gravity changes in the level
						printf("\nGravity changes:\n");
						for (int scanIndex = 0; scanIndex < theLevel.getGravityCount(); ++scanIndex) {
							GravityChange currGravChg = theLevel.getGravityAtIndex(scanIndex);
							printf("%i: X pos = %i\n", scanIndex + 1, currGravChg.xPos);
						}
						// Get desired number of gravity change to remove
						// and remove its index (the number minus 1) from the list
						// if in range
						printf("Enter the number of the gravity change object to remove (or -1 to stop): ");
						scanResult = scanf("%d", &remIndex);
						clearInput();
						if (scanResult == 1) {
							if (remIndex - 1 < 0 || remIndex > theLevel.getGravityCount()) {
								break;
							}
							theLevel.removeGravitySwitchAtIndex(remIndex - 1);
							printf("Gravity change %i removed!\n", remIndex);
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Remove rising blocks
					else if (choice == 5) {
						// Display all rising blocks objects in the level
						printf("\nRising blocks:\n");
						for (int scanIndex = 0; scanIndex < theLevel.getRisingCount(); ++scanIndex) {
							RisingBlocks currRisBlk = theLevel.getRisingAtIndex(scanIndex);
							printf("%i: Start X = %i, End X = %i\n", scanIndex + 1, currRisBlk.startX, currRisBlk.endX);
						}
						// Get desired number of rising blocks object to remove
						// and remove its index (the number minus 1) from the list
						// if in range
						printf("Enter the number of the rising blocks object to remove (or -1 to stop): ");
						scanResult = scanf("%d", &remIndex);
						clearInput();
						if (scanResult == 1) {
							if (remIndex - 1 < 0 || remIndex > theLevel.getRisingCount()) {
								break;
							}
							theLevel.removeRisingBlocksAtIndex(remIndex - 1);
							printf("Rising blocks %i removed!\n", remIndex);
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Remove falling blocks
					else if (choice == 6) {
						// Display all falling blocks objects in the level
						printf("Falling blocks:\n");
						for (int scanIndex = 0; scanIndex < theLevel.getFallingCount(); ++scanIndex) {
							FallingBlocks currFallBlk = theLevel.getFallingAtIndex(scanIndex);
							printf("%i: Start X = %i, End X = %i\n", scanIndex + 1, currFallBlk.startX, currFallBlk.endX);
						}
						// Get desired number of falling blocks object to remove
						// and remove its index (the number minus 1) from the list
						// if in range
						printf("Enter the number of the falling blocks object to remove (or -1 to stop): ");
						scanResult = scanf("%d", &remIndex);
						clearInput();
						if (scanResult == 1) {
							if (remIndex - 1 < 0 || remIndex > theLevel.getFallingCount()) {
								break;
							}
							theLevel.removeFallingBlocksAtIndex(remIndex - 1);
							printf("Falling blocks %i removed!\n", remIndex);
						}
						else {
							printf("Could not retrieve input!\n");
						}
					}
					// Just break out of this loop if choice out-of-range
					else {
						break;
					}
				}
			}
		} while (choice > 0);

		// Write final level data from memory to the level file
		theLevel.writeDataToFile(filepath);
		printf("Dun!\n");
		system("pause");
	}
	
	return 0;
}