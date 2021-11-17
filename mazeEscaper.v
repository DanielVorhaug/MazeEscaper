//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-8-10
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================

module mazeEscaper ( input logic [size-1:0] maze[size-1:0],
                     input logic             clk,
                     input logic             rst,
                     output logic [N-1:0]           x,
                     output logic [N-1:0]           y,
                     output logic            done,
                     output logic [size-1:0] path[size-1:0]
                     );

   parameter size = 9;
   parameter N = 3;

   parameter FIND_START=0, FIND_STOP=1, PICK_NEXT=2,STOP=3;


   parameter RIGHT=0,LEFT=1, DOWN=2, UP=3,NONE=4;

   logic [3:0]                               state;
   logic [N-1:0]                             sx;
   logic [N-1:0]                             sy;
   int                                       i;
   int                                       waste;

   initial begin
      for(i=0;i<size;i++)
        path[i] = '0;
   end

   //Keep track of direction
   logic [2:0] direction;

   //Implement wall follower right
   always_ff @(posedge clk or posedge rst) begin

      if(rst) begin
         state <= FIND_STOP;
         x  = 0;
         y = 0;
         sx = 0;
         sy = size-1;
         direction = DOWN;
         done = 0;
         waste = 0;

      end
      else begin
         case(state)
           FIND_STOP:
             if(maze[size-1][sx])
               sx++;
             else
               state <= FIND_START;
           FIND_START:
             if(maze[0][x])
               x++;
             else begin
               path[y][x] = 1 ;

              if(sx == x && sy==y)
                state <= STOP;
              else
                state <= PICK_NEXT;
             end
           PICK_NEXT: begin
              case(direction)
                RIGHT: begin
                  if(~maze[y-1][x]) begin
                    direction <= UP;
                    y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end

                   else begin
                     direction <= NONE;
                  end
                end
                LEFT: begin
                   if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else begin
                     direction <= NONE;
                  end
                end
                UP: begin
                   if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else begin
                     direction <= NONE;
                  end

                end
                DOWN: begin
                   if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else begin
                     direction <= NONE;
                  end
                end
              endcase // case (direction)

              path[y][x] <= 1 ;

              if(sx == x && sy==y)
                state <= STOP;
              else begin
                case(direction) 
                RIGHT: begin
                  if(~maze[y-1][x]) begin
                    direction <= UP;
                    y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end

                   else begin
                     direction <= NONE;
                  end
                end
                LEFT: begin
                   if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else begin
                     direction <= NONE;
                  end
                end
                UP: begin
                   if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else begin
                     direction <= NONE;
                  end

                end
                DOWN: begin
                   if(~maze[y][x-1]) begin
                     direction <= RIGHT;
                     x -=1;
                  end
                   else if(~maze[y+1][x]) begin
                     direction <= DOWN;
                     y +=1;
                  end
                   else if(~maze[y][x+1]) begin
                     direction <= LEFT;
                     x +=1;
                  end
                   else if(~maze[y-1][x]) begin
                     direction <= UP;
                     y -=1;
                  end
                   else begin
                     direction <= NONE;
                  end
                end
                endcase

                path[y][x] <= 1 ;

                if(sx == x && sy==y)
                  state <= STOP;
                else
                  state <= PICK_NEXT;
              end


              
           end // case: PICK_NEXT

           STOP: begin
              done <= 1;
           end
         endcase
      end // else: !if(rst)
   end // always_ff @ (posedge clk or posedge rst)

endmodule
