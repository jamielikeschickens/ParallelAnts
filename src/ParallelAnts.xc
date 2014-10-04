/*
 * ParallelAnts.xc
 *
 *  Created on: 3 Oct 2014
 *      Author: jm13556
 */

#include <stdio.h>
#include <platform.h>


const unsigned char world[4][3] = {{10, 2, 6}, {0, 10, 8}, {1, 0, 7}, {7, 3, 6}};

typedef struct Position {
    int x;
    int y;
} Position;

typedef struct Ant {
    Position position;
    int food;
} Ant;

void increaseAntFoodCounter(Ant *ant);

void moveEast(Ant *ant) {
    if (ant->position.x == 3) {
        ant->position.x = 0;
    } else {
        ant->position.x += 1;
    }

    increaseAntFoodCounter(ant);
}

void moveSouth(Ant *ant) {
    if (ant->position.y == 2) {
        ant->position.y = 0;
    } else {
        ant->position.y += 1;
    }

    increaseAntFoodCounter(ant);
}

void increaseAntFoodCounter(Ant *ant) {
    int fertility = world[ant->position.x][ant->position.y];
    ant->food += fertility;
}

void printAntInfo(Ant ant) {
    printf("Food items: %d\n", ant.food);
}


void decideMove(Ant *ant) {
     int east_fertility, south_fertility;

    if (ant->position.x == 3) {
        east_fertility = world[0][ant->position.y];
    } else {
        east_fertility = world[ant->position.x + 1][ant->position.y];
    }

    if (ant->position.y == 2) {
        south_fertility = world[ant->position.x][0];
    } else {
        south_fertility = world[ant->position.x][ant->position.y + 1];
    }

    if (east_fertility > south_fertility) {
        moveEast(ant);
    } else {
        moveSouth(ant);
    }
}

{int, Position} ant(int x, int y) {
    Ant ant;
    ant.position.x = x;
    ant.position.y = y;
    ant.food = 0;

    for (int i=0; i < 2; ++i) {
        decideMove(&ant);
    }

    printAntInfo(ant);

    return {ant.food, ant.position};
}

int main(void) {

    int foodArray[4];
    Position positionArray[4];

    par {
        {foodArray[0], positionArray[0]} = ant(1, 0);
        {foodArray[1], positionArray[1]} = ant(2, 0);
        {foodArray[2], positionArray[2]} = ant(0, 1);
        {foodArray[3], positionArray[3]} = ant(2, 1);
    }

    int totalFood = 0;

    int meanX = 0;
    int meanY = 0;

    for (int i=0; i<4; ++i) {
        totalFood += foodArray[i];

        meanX += positionArray[i].x;
        meanY += positionArray[i].y;
    }

    printf("Total food: %d\n Mean position: (%d, %d)", totalFood, meanX, meanY);

    return 0;
}
