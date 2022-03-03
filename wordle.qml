//==============================================
//  Wordle for MuseScore
//  Copyright (©) 2022 Snake4Y5H
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//==============================================
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import FileIO 3.0
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.Wordle for MuseScore"
      description: "Now you can play Wordle in MuseScore 3.5! Makes your score engraving experience even more productive"
      version: "1.0"
      pluginType: "dock"
      dockArea: "Right"

      implicitHeight: game.implicitHeight * 1.5
      implicitWidth: game.implicitWidth

      FileIO 
      {
            id: myFileWordList
            onError: console.log("Failed to read lyrics file: " + myFileWordList.source);
      }

      FontLoader 
      { 
            id: defaultFont; 
            name: "Helvetica Neue" 
      }

      property var wordlist: []
      property var usableWords: []
      property var ansNum: 0
      property var ans: ""
      onRun: 
      {
            myFileWordList.source = 'file://' + filePath + '/wordlist.json'
            defaultFont.source = 'file://' + filePath + '/HelveticaNeueLTPro-Bd.otf'
            wordlist = JSON.parse(myFileWordList.read()).wordlist;
            usableWords = JSON.parse(myFileWordList.read()).usableWords;
            ansNum = Math.floor(Math.random() * (wordlist.length - 1));
            ans = wordlist[ansNum];
            answerInput.forceActiveFocus();
            puzzle.initialize();
            console.log(ans);
      }

      function validateAns(w)
      {
            if(w.length != 5) {console.log("length wack"); return false;}
            if(!isInWordList(w)) {console.log("word not in list"); return false;}
            console.log("Vibe check passed");
            return true;
      }
      function isInWordList(w)
      {
            for(var i = 0; i < usableWords.length; i++) if(usableWords[i] == w.toLowerCase()) return true;
            for(var i = 0; i < wordlist.length; i++) if(wordlist[i] == w.toLowerCase()) return true;
            return false;
      }
      function checkChar(k, answer)
      {
            var result = ""
            k = k.toLowerCase()
            answer = answer.toLowerCase()
            var charList = [];
            for(var i = 0; i < k.length; i++) charList.push(k.charAt(i));
            for(var i = 0; i < answer.length; i++)
            {
                  for(var j = 0; j < charList.length; j++)
                  {
                        if(charList[j] == "0") continue;
                        if(charList[j] == answer.charAt(i)) 
                        {
                              if(j == i)
                              {
                                    result += "对";
                              }
                              else
                              {
                                    result += "有";
                              }
                              charList[j] = "0";
                              break;
                        }
                  }
                  if(result.length <= i) result += "无";
            }
            return result;
      }

      readonly property var colorBorder: "#3A3A3C"
      readonly property var colorKeyboard: "#818384"
      readonly property var colorEmpty: "#121213" 
      readonly property var colorFilling: "#818384"
      readonly property var colorWrong: "#3A3A3C"
      readonly property var colorHas: "#B19F4C"
      readonly property var colorCorrect: "#618B55" 
      Column 
      {
            id: game
            Grid
            {
                  id: puzzle
                  columns: 5
                  rows: 6
                  spacing: 5
                  property var progress: 0
                  property var grid: [[r1c1,r1c2,r1c3,r1c4,r1c5],
                                    [r2c1,r2c2,r2c3,r2c4,r2c5],
                                    [r3c1,r3c2,r3c3,r3c4,r3c5],
                                    [r4c1,r4c2,r4c3,r4c4,r4c5],
                                    [r5c1,r5c2,r5c3,r5c4,r5c5],
                                    [r6c1,r6c2,r6c3,r6c4,r6c5]]
                  property var gridText: [[r1c1t,r1c2t,r1c3t,r1c4t,r1c5t],
                                          [r2c1t,r2c2t,r2c3t,r2c4t,r2c5t],
                                          [r3c1t,r3c2t,r3c3t,r3c4t,r3c5t],
                                          [r4c1t,r4c2t,r4c3t,r4c4t,r4c5t],
                                          [r5c1t,r5c2t,r5c3t,r5c4t,r5c5t],
                                          [r6c1t,r6c2t,r6c3t,r6c4t,r6c5t]]
                  function initialize()
                  {
                        progress = 0;
                        for(var i = 0; i < 6; i++)
                              for(var j = 0; j < 5; j++)
                              {
                                    puzzle.grid[i][j].width = enterInput.height;
                                    puzzle.grid[i][j].height = enterInput.height;
                                    puzzle.grid[i][j].border.color = colorBorder;
                                    puzzle.grid[i][j].border.width = 2;
                                    puzzle.gridText[i][j].color = "white"; 
                                    puzzle.gridText[i][j].font.family = defaultFont.name;
                                    puzzle.gridText[i][j].font.pointSize = 18; 
                                    puzzle.gridText[i][j].verticalAlignment = Text.AlignVCenter; 
                                    puzzle.gridText[i][j].horizontalAlignment = Text.AlignHCenter;
                                    puzzle.gridText[i][j].anchors.verticalCenter = puzzle.grid[i][j].verticalCenter;
                                    puzzle.gridText[i][j].anchors.horizontalCenter = puzzle.grid[i][j].horizontalCenter;
                              }
                  }
                  Rectangle { id: r1c1; color: colorEmpty; Text{id: r1c1t; text: "";}}
                  Rectangle { id: r1c2; color: colorEmpty; Text{id: r1c2t; text: "";}}
                  Rectangle { id: r1c3; color: colorEmpty; Text{id: r1c3t; text: "";}}
                  Rectangle { id: r1c4; color: colorEmpty; Text{id: r1c4t; text: "";}}
                  Rectangle { id: r1c5; color: colorEmpty; Text{id: r1c5t; text: "";}}

                  Rectangle { id: r2c1; color: colorEmpty; Text{id: r2c1t; text: "";}}
                  Rectangle { id: r2c2; color: colorEmpty; Text{id: r2c2t; text: "";}}
                  Rectangle { id: r2c3; color: colorEmpty; Text{id: r2c3t; text: "";}}
                  Rectangle { id: r2c4; color: colorEmpty; Text{id: r2c4t; text: "";}}
                  Rectangle { id: r2c5; color: colorEmpty; Text{id: r2c5t; text: "";}}

                  Rectangle { id: r3c1; color: colorEmpty; Text{id: r3c1t; text: "";}}
                  Rectangle { id: r3c2; color: colorEmpty; Text{id: r3c2t; text: "";}}
                  Rectangle { id: r3c3; color: colorEmpty; Text{id: r3c3t; text: "";}}
                  Rectangle { id: r3c4; color: colorEmpty; Text{id: r3c4t; text: "";}}
                  Rectangle { id: r3c5; color: colorEmpty; Text{id: r3c5t; text: "";}}

                  Rectangle { id: r4c1; color: colorEmpty; Text{id: r4c1t; text: "";}}
                  Rectangle { id: r4c2; color: colorEmpty; Text{id: r4c2t; text: "";}}
                  Rectangle { id: r4c3; color: colorEmpty; Text{id: r4c3t; text: "";}}
                  Rectangle { id: r4c4; color: colorEmpty; Text{id: r4c4t; text: "";}}
                  Rectangle { id: r4c5; color: colorEmpty; Text{id: r4c5t; text: "";}}

                  Rectangle { id: r5c1; color: colorEmpty; Text{id: r5c1t; text: "";}}
                  Rectangle { id: r5c2; color: colorEmpty; Text{id: r5c2t; text: "";}}
                  Rectangle { id: r5c3; color: colorEmpty; Text{id: r5c3t; text: "";}}
                  Rectangle { id: r5c4; color: colorEmpty; Text{id: r5c4t; text: "";}}
                  Rectangle { id: r5c5; color: colorEmpty; Text{id: r5c5t; text: "";}}

                  Rectangle { id: r6c1; color: colorEmpty; Text{id: r6c1t; text: "";}}
                  Rectangle { id: r6c2; color: colorEmpty; Text{id: r6c2t; text: "";}}
                  Rectangle { id: r6c3; color: colorEmpty; Text{id: r6c3t; text: "";}}
                  Rectangle { id: r6c4; color: colorEmpty; Text{id: r6c4t; text: "";}}
                  Rectangle { id: r6c5; color: colorEmpty; Text{id: r6c5t; text: "";}}
                  
                  property var finalProgress: 0;
                  function updateDisplay(checkResult, input)
                  {
                        if(progress >= 6) {console.log("attempt exhausted, please restart the game"); return false;}
                        console.log(checkResult);
                        for(var i = 0; i < checkResult.length; i++)
                        {
                              switch(checkResult.charAt(i))
                              {
                                    case '对': puzzle.grid[progress][i].color = colorCorrect; break;
                                    case '有': puzzle.grid[progress][i].color = colorHas; break;
                                    case '无': puzzle.grid[progress][i].color = colorWrong; break;
                                    default: console.log("updateDisplay(): ERROR");
                              }
                              puzzle.gridText[progress][i].text = input.charAt(i).toUpperCase();
                              puzzle.gridText[progress][i].height = puzzle.grid[progress][i].height; 
                              puzzle.gridText[progress][i].width = puzzle.grid[progress][i].width; 
                              puzzle.grid[progress][i].border.width = 0;
                        }
                        progress += 1; finalProgress += 1;
                        if(checkResult == "对对对对对") 
                        {
                              console.log("congratulations! 你对对对对对");
                              answerInput.readOnly = true;
                              answerInput.cursorVisible = false;
                              enterInput.text = "Share\nStatistics"
                              progress = 9; //⑨
                        }
                  }
            }
            Grid
            {
                  id: answerArea
                  columns: 2
                  rows: 1
                  spacing: 2
                  TextArea
                  {
                        id: answerInput
                        textFormat: TextEdit.PlainText
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        focus: true
                        persistentSelection: true
                        selectByMouse: true
                        cursorVisible: true
                        mouseSelectionMode: TextEdit.SelectCharacters
                        color: "black"
                        height: enterInput.height
                        width: r1c1.width * 3 + puzzle.spacing * 3
                        font.pointSize: enterInput.font.pointSize
                        font.family: enterInput.font.family
                        Keys.onReturnPressed: { if(validateAns(answerInput.text)){puzzle.updateDisplay(checkChar(ans, answerInput.text), answerInput.text); answerInput.text="";} }
                        property var tempText: ""
                        onTextChanged: //validate if the user text input is legit (only contains english alphabets)
                        {
                              if(puzzle.progress >= 6) 
                              {
                                    if(puzzle.progress == 9) text = "Congrats!"; //Victory prompt, ⑨ means you are smart
                                    else 
                                    {
                                          font.pointSize = 10; 
                                          text = "Good Luck Next Round!\n" + "Answer: " + ans; //Defeated prompt
                                          enterInput.text = "Share\nStatistics"
                                          answerInput.readOnly = true;
                                          answerInput.cursorVisible = false;
                                    } 
                                    return;
                              }

                              text = text.toUpperCase();
                              var changedChar = 0;
                              if(text.length > tempText.length) 
                              {
                                    if(tempText.length == 0) cursorPosition = 1; 
                                    for(var i = 0; i < text.length && tempText.length != 0; i++) 
                                    {
                                          changedChar = i;
                                          if(i > tempText.length - 1) {cursorPosition = i + 1; break;}
                                          if(tempText.charAt(i) != text.charAt(i)) {cursorPosition = i + 1; break;}
                                    }
                              }
                              else if(text.length < tempText.length) 
                              {
                                    if(text.length == 0) cursorPosition = 0;
                                    for(var i = 0; i < tempText.length && text.length != 0; i++) 
                                    {
                                          if(i > text.length - 1) {cursorPosition = i; break;}
                                          if(tempText.charAt(i) != text.charAt(i)) {cursorPosition = i; break;}
                                    }
                              } else return;
                              if(text.length > 5 || (!/[A-Za-z][A-Za-z]*$/.test(text.charAt(changedChar)) && text.length != 0)) 
                              {
                                    text = tempText.substring(0,changedChar) + tempText.substring(changedChar);
                                    cursorPosition = changedChar;
                              }
                              tempText = text;
                        }
                        background: Rectangle { color: "white"; anchors.fill: parent;}
                  }
                  Button
                  {
                        id: enterInput
                        font.family: defaultFont.name
                        text: "ENTER"
                        width: r1c1.width * 2 + puzzle.spacing
                        onClicked: 
                        { 
                              if(puzzle.progress >= 6)
                              {
                                    text = "Generated!";
                                    statisticsBoard.generateStatistics(); return;
                              }
                              if(validateAns(answerInput.text))
                              {
                                    puzzle.updateDisplay(checkChar(ans, answerInput.text), answerInput.text); 
                                    answerInput.text="";
                              } 
                        }
                  }
            }
            TextArea
            {
                  id: statisticsBoard
                  visible: false
                  textFormat: TextEdit.PlainText
                  selectByMouse: true
                  cursorVisible: false
                  function generateStatistics()
                  {
                        var statistics = "Wordle for MuseScore " + ansNum + " " + (answerInput.text.length > 10 ? "X" : puzzle.finalProgress) + "/6\n\n";
                        for(var i = 0; i < puzzle.finalProgress; i++)
                        {
                              for(var j = 0; j < 5; j++)
                              {
                                    switch(puzzle.grid[i][j].color.toString().toUpperCase())
                                    {
                                          case colorWrong: statistics += "⬛"; break;
                                          case colorHas: statistics += "🟨"; break;
                                          case colorCorrect: statistics += "🟩"; break;
                                    }
                              }
                              if(i != puzzle.finalProgress - 1) statistics += "\n";
                        }
                        text = statistics;
                        visible = true;
                        copy();
                        return; 
                  }
            }
            
      }
}