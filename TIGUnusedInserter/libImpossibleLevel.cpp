// Impossible Game level library by MysticAx0lotl
// modified by jwilins

#include "libImpossibleLevel.hpp"

//Source: https://codereview.stackexchange.com/a/22907
//modified to convert to and then return an unsigned char vector on the heap instead of a signed one on the stack
static std::vector<unsigned char>* ReadAllBytes(char const* filename)
{
    FILE* theFile = fopen(filename, "rb");

    if (!theFile) {
        return new std::vector<unsigned char>;
    }

    fseek(theFile, 0, SEEK_END);
    size_t pos = ftell(theFile);

    if (pos == 0) {
        return new std::vector<unsigned char>;
    }

    std::vector<char>* result = new std::vector<char>(pos);

    fseek(theFile, 0, SEEK_SET);
    fread(&result->at(0), pos, 1, theFile);

    std::vector<unsigned char>* returnVal = new std::vector<unsigned char>(pos);
    for(int i = 0; i < result->size(); i++)
    {
        returnVal->at(i) = static_cast<unsigned char>(result->at(i));
    }

    delete result;
    return returnVal;
}

//Java handles evereything in big-Endian
//Since TIG's level editor is written in java, ints and shorts are written as big-Endian
//They must be converted to little-Endian after being read to be useable here
//This function takes an array of chars and a byte to start from. 
//It bit-shifts the starting byte and the next three bytes, then joins them together into a single int
//file = loaded file as a array of chars, startingOffset = the byte to start processing from
int readIntFromJava(std::vector<unsigned char> file, int startingOffset)
{
    unsigned int bit1, bit2, bit3, bit4;
    bit1 = static_cast<unsigned int>(file[startingOffset]);
    bit2 = static_cast<unsigned int>(file[startingOffset + 1]);
    bit3 = static_cast<unsigned int>(file[startingOffset + 2]);
    bit4 = static_cast<unsigned int>(file[startingOffset + 3]);

    bit1 = bit1 << 24;
    bit2 = bit2 << 16;
    bit3 = bit3 << 8;
    //bit 4 doesn't get shifted

    unsigned int resultU = bit1 | bit2 | bit3 | bit4;
    int result = static_cast<int>(resultU);
    return result;
}

//This function takes an array of chars and a byte to start from. 
//It bit-shifts the starting byte and the next byte, then joins them together into a single short
//file = loaded file as a array of chars, startingOffset = the byte to start processing from
short readShortFromJava(std::vector<unsigned char> file, int startingOffset)
{
    unsigned short bit1, bit2;
    bit1 = static_cast<unsigned int>(file[startingOffset]);
    bit2 = static_cast<unsigned int>(file[startingOffset + 1]);

    bit1 = bit1 << 8;
    //bit 2 doesn't get shifted

    unsigned short resultU = bit1 | bit2;
    short result = static_cast<short>(resultU);
    return result;
}

//Java handles evereything in big-Endian
//Since TIG's level editor is written in java, ints and shorts are read as big-Endian
//They must be converted to little-Endian after being written to be accepted by the game
void writeJavaInt(FILE* datafile, int sourceInt)
{
    unsigned int swapSource = ((sourceInt & 0xFF000000) >> 24) |
							  ((sourceInt & 0x00FF0000) >> 8) |
							  ((sourceInt & 0x0000FF00) << 8) |
							  ((sourceInt & 0x000000FF) << 24);
    fwrite(reinterpret_cast<const char*>(&swapSource), sizeof(swapSource), 1, datafile);
}

//Java handles evereything in big-Endian
//Since TIG's level editor is written in java, ints and shorts are read as big-Endian
//They must be converted to little-Endian after being written to be accepted by the game
void writeJavaShort(FILE* datafile, short sourceShort)
{
    unsigned short swapSource = static_cast<unsigned short>((sourceShort >> 8) | (sourceShort << 8));
    fwrite(reinterpret_cast<const char*>(&swapSource), sizeof(swapSource), 1, datafile);
}

//Endianess doesn't matter for bools or char arrays, this function handles exporting those
void writeOtherData(FILE* datafile, unsigned char data)
{
    fwrite(reinterpret_cast<const char*>(&data), sizeof(data), 1, datafile);
}

//Constructor that throws an error if no filepath is given
Level::Level()
{
    printf("ERROR: Must provide a filepath!\n");
}

//Constructor that calls loadDataFromFile
//and initializes vector/char pointers
Level::Level(char const* filename)
{
	this->blockObjs = new std::vector<BlockObj>;
	this->backgroundSwitches = new std::vector<BgCon>;
	this->gravitySwitches = new std::vector<GravityChange>;
	this->risingSections = new std::vector<RisingBlocks>;
	this->fallingSections = new std::vector<FallingBlocks>;

	this->objNames[0] = "Platform";
	this->objNames[1] = "Spike";
	this->objNames[2] = "Pit";

	this->colorNames[0] = "blue";
	this->colorNames[1] = "yellow";
	this->colorNames[2] = "green";
	this->colorNames[3] = "violet";
	this->colorNames[4] = "pink";
	this->colorNames[5] = "black";

    this->loadDataFromFile(filename);
}

//Destructor that removes all data from the heap
Level::~Level()
{
    delete this->blockObjs;
    delete this->backgroundSwitches;
    delete this->gravitySwitches;
    delete this->risingSections;
    delete this->fallingSections;
}

//Parse level data from the given filepath, called by constructor
void Level::loadDataFromFile(char const* filepath)
{
    int currentByte = 0; //tracks the current byte in the file 
    std::vector<unsigned char> *level = ReadAllBytes(filepath); //load file from path, store in the heap
    
    //make sure we actually loaded data
    if (level->size() == 0)
    {
        printf("Loaded empty file; data will not be processed!\n");
    }
    else
    {
        //first four bytes in the file are the format version, stored as an int
        printf("Getting file format version...\n");
        this->formatVer = readIntFromJava(*level, currentByte);
        currentByte += 4;
        printf("Format version %i\n", this->formatVer);

        //the next byte is a bool seeing if custom graphics are enabled
        //printf("Checking if special graphics are enabled\n");
        this->customGraphicsEnabled = static_cast<bool>(level->at(currentByte));
        if(this->customGraphicsEnabled)
        {
            printf("Custom graphics enabled, this feature is undocumented, so the loader will likely break now\n");
        }
        currentByte += 1;

        //the next two bytes are the number of blocks in the level, stored as a short
        //printf("Attempting to read block count\n");
        this->numBlocks = readShortFromJava(*level, currentByte);
        //printf("There are %i blocks in the level\n", this->numBlocks);
        currentByte += 2;

        //One block uses nine bytes of data (bool + 2 ints = 1 + 2(4) = 9 bytes)
        //the next (9 * numBlocks) bytes are the data for each block
        BlockObj *currentBlock = new BlockObj;
    
        for(int currBlockNum = 0; currBlockNum < this->numBlocks; currBlockNum++)
        {
            currentBlock->objType = static_cast<int>(level->at(currentByte));
            //printf("The current block type is %s\n", this->objNames[currentBlock->objType]);
            currentByte++;
    
            currentBlock->xPos = readIntFromJava(*level, currentByte);
            //printf("The current block's xpos is %i\n", currentBlock->xPos);
            currentByte += 4;
    
            currentBlock->yPos = readIntFromJava(*level, currentByte);
            //printf("The current block's ypos is %i\n", currentBlock->yPos);
            currentByte += 4;
    
            currentBlock->indexInVec = currBlockNum;
            //printf("This block can be found at index %i\n", currentBlock->indexInVec);
            this->blockObjs->push_back(*currentBlock);
    
            //printf("Loaded object successfully!\n");
        }
    
        //printf("Loaded %u object(s)!\n", this->blockObjs->size());
        delete currentBlock;
    
        //the next four bytes are the x position of the end of the level, stored as an int
        this->endWallPos = readIntFromJava(*level, currentByte);
        //printf("End wall is located at X position %i\n", this->endWallPos);
        currentByte += 4;
    
        //the next four bytes are the number of color changes in the level, stored as an int
        //printf("Attempting to read color change count\n");
        this->numBgSwitch = readIntFromJava(*level, currentByte);
        //printf("There are %i color triggers in the level\n", this->numBgSwitch);
        currentByte += 4;
    
        //Assuming all background changes don't use custom graphics
        //Each background change takes up 9 bytes (same math as before, 2 ints + 1 bool)
        //Therefore the next (9 * numBgSwitch) bytes are background changes
        BgCon *currentBg = new BgCon;
    
        for(int currBgNum = 0; currBgNum < this->numBgSwitch; currBgNum++)
        {
            currentBg->xPos = readIntFromJava(*level, currentByte);
            //printf("The current color trigger's xpos is %i\n", currentBg->xPos);
            currentByte += 4;
    
            currentBg->customGraphics = static_cast<bool>(level->at(currentByte));
            currentByte++; //WILL BREAK HERE IF CUSTOM GRAPHICS ARE ENABLED FOR SOME REASON
    
            currentBg->colorID = readIntFromJava(*level, currentByte);
            //printf("The current color type is %s\n", this->colorNames[currentBg->colorID]);
            currentByte += 4;
    
            currentBg->indexInVec = currBgNum;
    
            //printf("This color trigger can be found at index %i\n", currentBg->indexInVec);
            this->backgroundSwitches->push_back(*currentBg);
    
            //printf("Loaded color trigger successfully!\n");
        }
    
        //printf("Loaded %i color trigger(s)!\n", this->backgroundSwitches->size());
        delete currentBg;
    
        //The next 4 bytes are the number of gravity changes in the level, stored as an int
        printf("Attempting to read gravity change count\n");
        this->numGravitySwitch = readIntFromJava(*level, currentByte);
        printf("There are %i gravity changes in the level\n", this->numGravitySwitch);
        currentByte += 4;
    
        //Each gravity change only takes up 4 bytes (1 int = 4 bytes)
        //Therefore, the next (4 * numGravitySwitch) bytes are gravity switch data
        GravityChange *currentGrav = new GravityChange;
    
        for(int currGravNum = 0; currGravNum < this->numGravitySwitch; currGravNum++)
        {
            currentGrav->xPos = readIntFromJava(*level, currentByte);
            printf("The current gravity trigger's xpos is %i\n", currentGrav->xPos);
            currentByte += 4;
    
            currentGrav->indexInVec = currGravNum;
    
            printf("This gravity trigger can be found at index %i\n", currentGrav->indexInVec);
            this->gravitySwitches->push_back(*currentGrav);
    
            printf("Loaded gravity trigger successfully!\n");
        }
    
        printf("Loaded %i gravity trigger(s)!\n", this->gravitySwitches->size());
        delete currentGrav;
    
        //The next 4 bytes are the number of falling block fade effects, stored as an int
        printf("Attempting to read falling block count\n");
        this->numFallingBlocks = readIntFromJava(*level, currentByte);
        printf("There are %i falling blocks in the level\n", this->numFallingBlocks);
        currentByte += 4;
    
        //Each falling block object takes up 8 bytes (2 ints = 2 * 4 bytes = 8 bytes)
        //Therefore the next (8 * numFallingBlocks) bytes are Falling Blocks data
        FallingBlocks *currentFalling = new FallingBlocks;
    
        for(int currFallingNum = 0; currFallingNum < this->numFallingBlocks; currFallingNum++)
        {
            currentFalling->startX = readIntFromJava(*level, currentByte);
            printf("The current falling block startX is %i\n", currentFalling->startX);
            currentByte += 4;
    
            currentFalling->endX = readIntFromJava(*level, currentByte);
            printf("The current falling block endX is %i\n", currentFalling->endX);
            currentByte += 4;
    
            currentFalling->indexInVec = currFallingNum;
    
            printf("This falling block section can be found at index %i\n", currentFalling->indexInVec);
            this->fallingSections->push_back(*currentFalling);
    
            printf("Loaded falling block section successfully!\n");
        }
    
        printf("Loaded %i falling section(s)!\n", this->fallingSections->size());
        delete currentFalling;
    
        //The next 4 bytes are the number of rising block fade effects, stored as an int
        printf("Attempting to read rising block count\n");
        this->numRisingBlocks = readIntFromJava(*level, currentByte);
        printf("There are %i rising blocks in the level\n", numRisingBlocks);
        currentByte += 4;

        //Each rising block object takes up 8 bytes (2 ints = 2 * 4 bytes = 8 bytes)
        //Therefore the next (8 * numRisingBlocks) bytes are Rising Blocks data
        RisingBlocks *currentRising = new RisingBlocks;
    
        for(int currRisingNum = 0; currRisingNum < this->numRisingBlocks; currRisingNum++)
        {
            currentRising->startX = readIntFromJava(*level, currentByte);
            printf("The current rising block startX is %i\n", currentRising->startX);
            currentByte += 4;
    
            currentRising->endX = readIntFromJava(*level, currentByte);
            printf("The current rising block endX is %i\n", currentRising->endX);
            currentByte += 4;
    
            currentRising->indexInVec = currRisingNum;
    
            printf("This rising block section can be found at index %i\n", currentRising->indexInVec);
            this->risingSections->push_back(*currentRising);
    
            printf("Loaded rising block section successfully!\n");
        }
    
        printf("Loaded %i rising section(s)!\n", this->risingSections->size());
        delete currentRising;
    }

    printf("Loaded entire level!\n");
    delete level; //all data is now stored in the class, the raw level data is no longer needed
}

void Level::writeDataToFile(char const* filepath)
{
    FILE* dataOut = fopen(filepath, "wb");
    if (!dataOut) {
        printf("Failed to write level data to file...\n");
        return;
    }
    writeJavaInt(dataOut, this->formatVer);
    writeOtherData(dataOut, this->customGraphicsEnabled);
    writeJavaShort(dataOut, this->numBlocks);
    BlockObj temp;
    for(int currBlockNum = 0; currBlockNum < this->numBlocks; currBlockNum++)
    {
        temp = this->getBlockAtIndex(currBlockNum);
        writeOtherData(dataOut, temp.objType);
        writeJavaInt(dataOut, temp.xPos);
        writeJavaInt(dataOut, temp.yPos);
    }
    writeJavaInt(dataOut, endWallPos);
    writeJavaInt(dataOut, numBgSwitch);
    BgCon tempCon;
    for(int currBgNum = 0; currBgNum < numBgSwitch; currBgNum++)
    {
        tempCon = this->getBgConAtIndex(currBgNum);
        writeJavaInt(dataOut, tempCon.xPos);
        writeOtherData(dataOut, tempCon.customGraphics);
        //Will need reworking once I can figure out how the custom graphics work
        if(tempCon.customGraphics)
        {
            printf("the program will break now\n");
        }
        else
        {
            writeJavaInt(dataOut, tempCon.colorID);
        }
    }
    writeJavaInt(dataOut, this->numGravitySwitch);
    GravityChange tempGrav;
    for(int currGravNum = 0; currGravNum < this->numGravitySwitch; currGravNum++)
    {
        tempGrav = this->getGravityAtIndex(currGravNum);
        writeJavaInt(dataOut, tempGrav.xPos);
    }
    writeJavaInt(dataOut, this->numFallingBlocks);
    FallingBlocks tempFalling;
    for(int currFallingNum = 0; currFallingNum < this->numFallingBlocks; currFallingNum++)
    {
        tempFalling = this->getFallingAtIndex(currFallingNum);
        writeJavaInt(dataOut, tempFalling.startX);
        writeJavaInt(dataOut, tempFalling.endX);
    }
    writeJavaInt(dataOut, this->numRisingBlocks);
    RisingBlocks tempRising;
    for (int currRisingNum = 0; currRisingNum < this->numRisingBlocks; currRisingNum++)
    {
        tempRising = this->getRisingAtIndex(currRisingNum);
        writeJavaInt(dataOut, tempRising.startX);
        writeJavaInt(dataOut, tempRising.endX);
    }
}

//The following methods are all explained in the hpp file
int Level::getFormatVer()
{
    return this->formatVer;
}

BlockObj Level::getBlockAtIndex(int index)
{
    if(index < this->numBlocks)
    {
        return this->blockObjs->at(index);
    }
    else
    {
        BlockObj nullObj = {0, 0, 0, 0};
        return nullObj;
    }
}

BgCon Level::getBgConAtIndex(int index)
{
    if(index < this->numBgSwitch)
    {
        return this->backgroundSwitches->at(index);
    }
    else
    {
        BgCon nullObj = {0, 0, "null", false, "null", 0};
        return nullObj;
    }

}

GravityChange Level::getGravityAtIndex(int index)
{
    if(index < this->numGravitySwitch)
    {
        return this->gravitySwitches->at(index);
    }
    else
    {
        GravityChange nullObj = {0, 0};
        return nullObj;
    }
}

RisingBlocks Level::getRisingAtIndex(int index)
{
    if(index < this->numRisingBlocks)
    {
        return this->risingSections->at(index);
    }
    else
    {
        RisingBlocks nullObj = {0, 0, 0};
        return nullObj;
    }
}

FallingBlocks Level::getFallingAtIndex(int index)
{
    if(index < this->numFallingBlocks)
    {
        return this->fallingSections->at(index);
    }
    else
    {
        FallingBlocks nullObj = {0, 0, 0};
        return nullObj;
    }
}

int Level::getEndPos()
{
    return this->endWallPos;
}

int Level::getObjCount()
{
    return this->numBlocks;
}

int Level::getBgCount()
{
    return this->numBgSwitch;
}

int Level::getGravityCount()
{
    return this->numGravitySwitch;
}

int Level::getRisingCount()
{
    return this->numRisingBlocks;
}

int Level::getFallingCount()
{
    return this->numFallingBlocks;
}

void Level::addNewBlock(BlockObj toAdd)
{
    toAdd.indexInVec = this->numBlocks;
    numBlocks++;
    this->blockObjs->push_back(toAdd);
}

void Level::addBgCon(BgCon toAdd)
{
    toAdd.indexInVec = this->numBgSwitch;
    numBgSwitch++;
    toAdd.colorName = this->colorNames[toAdd.colorID];
    this->backgroundSwitches->push_back(toAdd);
}

void Level::addGravitySwitch(GravityChange toAdd)
{
    toAdd.indexInVec = this->numGravitySwitch;
    numGravitySwitch++;
    this->gravitySwitches->push_back(toAdd);
}

void Level::addGravitySwitchInOrder(GravityChange toAdd)
{
    for (toAdd.indexInVec = 0; 
        toAdd.indexInVec < this->numGravitySwitch && 
        toAdd.xPos > this->gravitySwitches->at(toAdd.indexInVec).xPos; 
        ++toAdd.indexInVec);
    numGravitySwitch++;
    this->gravitySwitches->insert(this->gravitySwitches->begin() + toAdd.indexInVec, toAdd);
}

void Level::addRisingBlocks(RisingBlocks toAdd)
{
    toAdd.indexInVec = this->numRisingBlocks;
    numRisingBlocks++;
    this->risingSections->push_back(toAdd);
}

void Level::addRisingBlocksInOrder(RisingBlocks toAdd)
{
    for (toAdd.indexInVec = 0;
        toAdd.indexInVec < this->numRisingBlocks &&
        toAdd.startX > this->risingSections->at(toAdd.indexInVec).startX;
        ++toAdd.indexInVec);
    numRisingBlocks++;
    this->risingSections->insert(this->risingSections->begin() + toAdd.indexInVec, toAdd);
}

void Level::addFallingBlocks(FallingBlocks toAdd)
{
    toAdd.indexInVec = this->numFallingBlocks;
    numFallingBlocks++;
    this->fallingSections->push_back(toAdd);
}

void Level::addFallingBlocksInOrder(FallingBlocks toAdd)
{
    for (toAdd.indexInVec = 0;
        toAdd.indexInVec < this->numFallingBlocks &&
        toAdd.startX > this->fallingSections->at(toAdd.indexInVec).startX;
        ++toAdd.indexInVec);
    numFallingBlocks++;
    this->fallingSections->insert(this->fallingSections->begin() + toAdd.indexInVec, toAdd);
}

void Level::setEndPos(int endPos)
{
    this->endWallPos = endPos;
}

//The if-else statements in the AtIndex methods make sure that the index is in range
void Level::removeBlockAtIndex(int index)
{
    if(index < this->numBlocks)
    {
        this->blockObjs->erase(this->blockObjs->begin() + index);
        this->numBlocks--;
    }
}

//The if-else statements in the removeLast methods make sure that the appropriate vectors contain data 
void Level::removeLastBlock()
{
    if(this->numBlocks > 0)
    {
        this->blockObjs->pop_back();
        this->numBlocks--;
    }
}

void Level::removeBgConAtIndex(int index)
{
    if(index < this->numBgSwitch)
    {
        this->backgroundSwitches->erase(this->backgroundSwitches->begin() + index);
        this->numBgSwitch--;
    }
}

void Level::removeLastBgCon()
{
    if(this->numBgSwitch > 0)
    {
        this->backgroundSwitches->pop_back();
        this->numBgSwitch--;
    }
}

void Level::removeGravitySwitchAtIndex(int index)
{
    if(index < this->numGravitySwitch)
    {
        this->gravitySwitches->erase(this->gravitySwitches->begin() + index);
        this->numGravitySwitch--;
    }
}

void Level::removeLastGravitySwitch()
{
    if(this->numGravitySwitch > 0)
    {
        this->gravitySwitches->pop_back();
        this->numGravitySwitch--;
    }
}

void Level::removeRisingBlocksAtIndex(int index)
{
    if(index < this->numRisingBlocks)
    {
        this->risingSections->erase(this->risingSections->begin() + index);
        this->numRisingBlocks--;
    }
}

void Level::removeLastRisingBlocks()
{
    if(this->numRisingBlocks > 0)
    {
        this->risingSections->pop_back();
        this->numRisingBlocks--;
    }
}

void Level::removeFallingBlocksAtIndex(int index)
{
    if(index < this->numFallingBlocks)
    {
        this->fallingSections->erase(this->fallingSections->begin() + index);
        this->numFallingBlocks--;
    }
}

void Level::removeLastFallingBlocks()
{
    if(this->numFallingBlocks > 0)
    {
        this->fallingSections->pop_back();
        this->numFallingBlocks--;
    }
}

void Level::printAllInfo()
{

}
