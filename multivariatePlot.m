function multivariatePlot
  % Root panel
  f = figure;
  p = uipanel(f, 'Position', [0 0 1 1]);

  % PUsh button for plotting graph
  plotDataBtn = uicontrol(p, 'Style', 'pushbutton');
  plotDataBtn.Position = [10 25 100 50];
  plotDataBtn.String = 'Plot Data';
  plotDataBtn.Callback = @plotButtonPushed;

  % Push button for plot again
  plotAgainBtn = uicontrol('Style', 'pushbutton');
  plotAgainBtn.Position = [10 25 100 50];
  plotAgainBtn.String = 'Plot Again';
  plotAgainBtn.Visible = 'off';
  plotAgainBtn.Callback = @toggleUIVisible;

  % Coordinate type selection
  coordSelPanel = uipanel(p, 'Position', [0.005 0.25 0.3 0.2]);
  coordSelPanel.Title = 'Coordinate Type';
  cTypeLabel = uicontrol(coordSelPanel, 'Style', 'text');
  cTypeLabel.String = 'Select your coordinate type:';
  % cTypeLabel.Position = [5 190 220 20];
  cTypeLabel.Position = [1 50 200 20];
  coordTypePopUpMenu = uicontrol(coordSelPanel, 'Style', 'popupmenu');
  coordTypePopUpMenu.Position = [25 25 100 20];
  coordTypeCellArray = {'Rectangular', 'Cylindrical', 'Spherical'};
  coordTypePopUpMenu.String = coordTypeCellArray;
  coordTypePopUpMenu.Callback = @selectCoordType;

  % Range1 for three coordinate types
  [recRange1Panel,...
   recMinRange1Input,...
   recMaxRange1Input] = rangePanelFactory('Rectangular X Value:',...
                                          [0 0.7 0.3 0.3],...
                                          [0 95 100 20],...
                                          [70 98 100 20]);
  % Default of rectangular's x boundary values
  recMinRange1Input.String = '-10';
  recMaxRange1Input.String = '10';

  [cyRange1Panel,...
   cyMinRange1Input,...
   cyMaxRange1Input] = rangePanelFactory('Cylindrical R Value:',...
                                         [0 0.7 0.3 0.3],...
                                         [0 95 100 20],...
                                         [70 98 100 20]);
  % Default of cylindrical's r boundary values
  cyMinRange1Input.String = '0';
  cyMaxRange1Input.String = '10';

  [sphRange1Panel,...
   sphMinRange1Input,...
   sphMaxRange1Input] = rangePanelFactory('Spherical Theta Value (Radian):',...
                                          [0 0.7 0.3 0.3],...
                                          [0 95 100 20],...
                                          [70 98 100 20]);
  % Default spherical's theta boundary values
  sphMinRange1Input.String = '0';
  sphMaxRange1Input.String = '6.28318530717959';

  % Range2 for three coordinate types
  [recRange2Panel,...
   recMinRange2Input,...
   recMaxRange2Input] = rangePanelFactory('Rectangular y Value:',...
                                          [0.32 0.7 0.3 0.3],...
                                          [0 95 100 20],...
                                          [70 98 100 20]);
  % Default rectangular's y boundary values
  recMinRange2Input.String = '-10';
  recMaxRange2Input.String = '10';

  [cyRange2Panel,...
   cyMinRange2Input,...
   cyMaxRange2Input] = rangePanelFactory('Cylindrical Theta Value (Radian):',...
                                         [0.32 0.7 0.3 0.3],...
                                         [0 95 100 20],...
                                         [70 98 100 20]);
  % Default cylindrical's theta boundary values
  cyMinRange2Input.String = '0';
  cyMaxRange2Input.String = '6.28318530717959';

  [sphRange2Panel,...
   sphMinRange2Input,...
   sphMaxRange2Input] = rangePanelFactory('Spherical Phi Value (Radian):',...
                                          [0.32 0.7 0.3 0.3],...
                                          [0 95 100 20],...
                                          [70 98 100 20]);
  % Default spherical's phi boundary values
  sphMinRange2Input.String = '0';
  sphMaxRange2Input.String = '6.28318530717959';

  % Turn visibility of cylindrical and spherical panel off
  cyRange1Panel.Visible = 'off';
  sphRange1Panel.Visible = 'off';
  cyRange2Panel.Visible = 'off';
  sphRange2Panel.Visible = 'off';

  % Equation related UI
  eqnPanel = uipanel(p, 'Position', [0 0.5 0.3 0.15]);
  eqnPanel.Title = 'Equation';
  eqnLabel = uicontrol(eqnPanel, 'Style', 'text');
  eqnLabel.String = 'Please enter your equation here:';
  eqnLabel.Position = [5 30 200 20];
  eqnInput = uicontrol(eqnPanel, 'Style', 'edit');
  eqnInput.Position = [10 10 180 20];

  % ============== Graph Customization ==========================
  % Graph Style (surface or mesh plot)
  % gStylePanel = uipanel(p, 'Position', [0.32 0.5 0.3 0.15])
  % gStylePanel.Title = 'Graph Style';
  gStyleBG = uibuttongroup(p,...
                           'Position', [0.32 0.5015 0.3 0.15],...
                           'Visible', 'off',...
                           'SelectionChangedFcn', @selectGraphStyle);
  gsBtn1 = uicontrol(gStyleBG,...
                    'Style', 'radiobutton',...
                    'String', 'surf',...
                    'Position', [10 30 70 20],...
                    'HandleVisibility', 'off');
  gsBtn2 = uicontrol(gStyleBG,...
                    'Style', 'radiobutton',...
                    'String', 'mesh',...
                    'Position', [10 10 70 20],...
                    'HandleVisibility', 'off');
  gStyleBG.Visible = 'on';
  gStyleBG.Title = 'Graph Style';

  % Shading style
  shadingStyleBG = uibuttongroup(p,...
                                 'Position', [0.32 0.25 0.3 0.20],...
                                 'Visible', 'off',...
                                 'SelectionChangedFcn', @selectShadingStyle);
  csBtn1 = uicontrol(shadingStyleBG,...
                    'Style', 'radiobutton',...
                    'String', 'faceted',...
                    'Position', [10 50 70 20],...
                    'HandleVisibility', 'off');
  csBtn2 = uicontrol(shadingStyleBG,...
                    'Style', 'radiobutton',...
                    'String', 'interp',...
                    'Position', [10 30 70 20],...
                    'HandleVisibility', 'off');
  csBtn3 = uicontrol(shadingStyleBG,...
                    'Style', 'radiobutton',...
                    'String', 'flat',...
                    'Position', [10 10 70 20],...
                    'HandleVisibility', 'off');
  shadingStyleBG.Visible = 'on';
  shadingStyleBG.Title = 'Shading Style';

  % ------------- colormap & colorbar ------------------------
  colorMapBG = uibuttongroup(p,...
                            'Position', [0.64 0.55 0.35 0.45],...
                            'Visible', 'off',...
                            'SelectionChangedFcn', @selectedColor);
  cmBtn1 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Default',...
                    'Position', [10 190 90 20],...
                    'HandleVisibility', 'off');
  cmBtn2 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Spring',...
                    'Position', [10 170 90 20],...
                    'HandleVisibility', 'off');
  cmBtn3 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Summer',...
                    'Position', [10 150 90 20],...
                    'HandleVisibility', 'off');
  cmBtn4 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Autumn',...
                    'Position', [10 130 70 20],...
                    'HandleVisibility', 'off');
  cmBtn5 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Winter',...
                    'Position', [10 110 70 20],...
                    'HandleVisibility', 'off');
  cmBtn6 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Parula',...
                    'Position', [10 90 70 20],...
                    'HandleVisibility', 'off');
  cmBtn7 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Jet',...
                    'Position', [10 70 70 20],...
                    'HandleVisibility', 'off');
  cmBtn8 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Hsv',...
                    'Position', [10 50 70 20],...
                    'HandleVisibility', 'off');
  cmBtn9 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Hot',...
                    'Position', [10 30 70 20],...
                    'HandleVisibility', 'off');
  cmBtn10 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Cool',...
                    'Position', [10 10 70 20],...
                    'HandleVisibility', 'off');
  cmBtn11 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Gray',...
                    'Position', [120 190 70 20],...
                    'HandleVisibility', 'off');
  cmBtn12 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Bone',...
                    'Position', [120 170 70 20],...
                    'HandleVisibility', 'off');
  cmBtn13 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Copper',...
                    'Position', [120 150 70 20],...
                    'HandleVisibility', 'off');
  cmBtn14 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Pink',...
                    'Position', [120 130 70 20],...
                    'HandleVisibility', 'off');
  cmBtn15 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Lines',...
                    'Position', [120 110 70 20],...
                    'HandleVisibility', 'off');
  cmBtn16 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Colorcube',...
                    'Position', [120 90 90 20],...
                    'HandleVisibility', 'off');
  cmBtn17 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Prism',...
                    'Position', [120 70 70 20],...
                    'HandleVisibility', 'off');
  cmBtn18 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'Flag',...
                    'Position', [120 50 70 20],...
                    'HandleVisibility', 'off');
  cmBtn19 = uicontrol(colorMapBG,...
                    'Style', 'radiobutton',...
                    'String', 'White',...
                    'Position', [120 30 70 20],...
                    'HandleVisibility', 'off');
  colorMapBG.Visible = 'on';
  colorMapBG.Title = 'ColorMap';
  
  % Alpha Channel
  alphaChnPanel = uipanel(p, 'Position', [0.64 0.40 0.35 0.1]);
  alphaChnPanel.Title = 'Alpha Value';
  alphaLabel = uicontrol(alphaChnPanel, 'Style', 'text');
  alphaLabel.String = 'Alpha: ';
  alphaLabel.Position = [10 10 50 20];
  % Input box
  alphaInput = uicontrol(alphaChnPanel, 'Style', 'edit');
  alphaInput.Position = [140 12 50 20];
  alphaInput.String = '1';
  alphaInput.Callback = @inSetAlphaValue;
  % Slider
  alphaSlider = uicontrol(alphaChnPanel,...
                          'Style', 'slider',...
                          'Position', [60 12 70 20],...
                          'Min', 0,...
                          'Max', 1);
  alphaSlider.Value = 1;
  addlistener(alphaSlider,...
             'Value', 'PostSet',...
             @sldSetAlphaValue);
  

  % --------------------------------------------------------------
  % ---------------- Global default variables --------------------
  % Coordinate type
  curGraphTypeIndx = coordTypePopUpMenu.Value;
  minRange1 = 0;
  maxRange1 = 0;
  minRange2 = 0;
  maxRange2 = 0;
  graphStyle = 'surf';
  shadingStyle = 'faceted';
  colorBar = 1;
  colorMap = 'default';
  alphaVal = 1;

  function setRange()
    if curGraphTypeIndx == 1
      minRange1 = recMinRange1Input.String;
      maxRange1 = recMaxRange1Input.String;
      minRange2 = recMinRange2Input.String;
      maxRange2 = recMaxRange2Input.String;
    elseif curGraphTypeIndx == 2
      minRange1 = cyMinRange1Input.String;
      maxRange1 = cyMaxRange1Input.String;
      minRange2 = cyMinRange2Input.String;
      maxRange2 = cyMaxRange2Input.String;
    else
      minRange1 = sphMinRange1Input.String;
      maxRange1 = sphMaxRange1Input.String;
      minRange2 = sphMinRange2Input.String;
      maxRange2 = sphMaxRange2Input.String;
    end
  end

  function toggleUIVisible(src, event)
    p.Visible = 'on';
    plotAgainBtn.Visible = 'off';
  end

  function selectCoordType(src, event)
    curGraphTypeIndx = coordTypePopUpMenu.Value;

    if curGraphTypeIndx == 1
      % Rectangular
      recRange1Panel.Visible = 'on';
      recRange2Panel.Visible = 'on';
      cyRange1Panel.Visible = 'off';
      cyRange2Panel.Visible = 'off';
      sphRange1Panel.Visible = 'off';
      sphRange2Panel.Visible = 'off';
    end

    if curGraphTypeIndx == 2
      % Cylindrical
      recRange1Panel.Visible = 'off';
      recRange2Panel.Visible = 'off';
      cyRange1Panel.Visible = 'on';
      cyRange2Panel.Visible = 'on';
      sphRange1Panel.Visible = 'off';
      sphRange2Panel.Visible = 'off';
    end

    if curGraphTypeIndx == 3
      % Spherical
      recRange1Panel.Visible = 'off';
      recRange2Panel.Visible = 'off';
      cyRange1Panel.Visible = 'off';
      cyRange2Panel.Visible = 'off';
      sphRange1Panel.Visible = 'on';
      sphRange2Panel.Visible = 'on';
    end
  end

  % gStyleBG callback
  function selectGraphStyle(src, event)
    graphStyle = event.NewValue.String;
  end

  % shadingStyleBG callback
  function selectShadingStyle(src, event)
    shadingStyle = event.NewValue.String;
    disp(['Current: ' shadingStyle])
  end

  % colorMapBG callback
  function selectedColor(src, event)
    colorMap = lower(event.NewValue.String);
  end

  % Set Slider and alphaVal (input box)
  function inSetAlphaValue(src, event)
    alphaSlider.Value = str2double(alphaInput.String);
    alphaVal = alphaInput.String;
  end

  % Set input box and alphaVal (slider)
  function sldSetAlphaValue(src, event)
    val = event.AffectedObject.Value;
    alphaInput.String = round(val, 2);
    alphaVal = alphaInput.String;
  end

  % Range panel factory
  function [rangePanel,...
            minRangeInput,...
            maxRangeInput] = rangePanelFactory(labelStr, panelPos, labelPos, inputBxPos)
    % labelStr: Label String for title
    % panelPos: Position matrix for panel
    % labelPos: Position matrix for label
    % inputBxPos: Position matrix for input box

    rangePanel = uipanel(p, 'Position', panelPos);
    rangePanel.Title = labelStr;

    % Range UI
    minRangeLabel = uicontrol(rangePanel, 'Style', 'text');
    minRangeLabel.String = 'Min:';
    minRangeLabel.Position = labelPos;
    minRangeInput = uicontrol(rangePanel, 'Style', 'edit');
    minRangeInput.Position = inputBxPos;

    maxRangeLabel = uicontrol(rangePanel, 'Style', 'text');
    maxRangeLabel.String = 'Max:';
    maxRangeLabel.Position = [labelPos(1), (labelPos(2) - 40), labelPos(3), labelPos(4)];
    maxRangeInput = uicontrol(rangePanel, 'Style', 'edit');
    maxRangeInput.Position = [inputBxPos(1), inputBxPos(2) - 40, inputBxPos(3), inputBxPos(4)];
  end

  % Main plot function
  function plotButtonPushed(src, event)
    % p.Visible = 'off';
    % bg.Visible = 'off';
    p.Visible = 'off';
    plotAgainBtn.Visible = 'on';

    % Custom input dialog to suit per usage
    % function [usrReply] = customInputDlg(promptL, title, default)
    %   prompt = promptL;
    %   t = title;
    %   dims = [1 35];
    %   definput = default;

    %   % Set tex as default interpreter to parse special symbol
    %   opts.Interpreter = 'tex';
    %   usrReply = inputdlg(prompt, t, dims, definput, opts);
    % end

    % Custom list dialog to suit per usage
    % function [indx, tf] = customListDlg(pStr, sMod, name, lStr)
    %   [indx, tf] = listdlg('PromptString', pStr,...
    %                       'SelectionMode', sMod,...
    %                       'ListSize', [190 120],...j
    %                       'Name', name,...
    %                       'ListString', lStr);
    % end

    % Coordinate point factory
    function [X, Y, Z] = points(t, fun, r1, r2)
      % t: Type of graph.
      %    'r' = Rectangular
      %    'c' = Cylindrical
      %    's' = Spherical
      % fun: String representation of equation (annonymous function)
      % r1: Range matrix for first range. e.g: [min_range1, max_range1]
      % r2: Range matrix for second range. e.g: [min_range2, max_range2]

      numPoints = 100;

      % Arrays of 50 points from min -> max
      xRange = linspace(r1(1), r1(2), numPoints);
      yRange = linspace(r2(1), r2(2), numPoints);

      % Meshgrid of X and Y points
      [X, Y] = meshgrid(xRange, yRange); % This generates the actual grid of x and y values.
  
      F = fun;
      Z = F(X, Y);
      
      if strcmpi(t, 'c')
        [X, Y] = pol2cart(Y, X);
      end
      
      if strcmpi(t, 's')
        [X, Y, Z] = sph2cart(X, Y, Z);
      end
    end

    % Plotting graph
    function plotting_graph(X, Y, Z)
      figure(1);

      if strcmpi(graphStyle, 'surf')
        % surface plot
        s = surf(X,Y,Z);             % The surface plotting function.
      else
        s = mesh(X, Y, Z);
      end

      colormap(colorMap);

      % origin axes
      xl = xlim();
      yl = ylim();
      zl = zlim();
      hold on;
      line(xl, [0,0], [0,0], 'LineWidth', 1, 'Color', 'k');
      line([0,0], yl, [0,0], 'LineWidth', 1, 'Color', 'k');
      line([0,0], [0,0], zl, 'LineWidth', 1, 'Color', 'k');
      
      % ------------ Styling ------------------
      if colorBar
        colorbar
      end

      % interpolate the colormap across the surface face    
      % default to interp if the user cancel the list selection dialog
      shading(gca, shadingStyle);

      % alpha channel
      alpha(alphaVal);    % set transparency to 0.8

      title('3D-Plot');
      % label axes
      xlabel('x-axis');
      ylabel('y-axis');
      zlabel('z-axis');
      hold off
    end

    % Turn multiplication, division and power to element-wise op
    function modEqn = elemWiseEqn(eqn)
      % eqn: Normal equation from user. e.g: x^2 + y^2
      % output modEqn: Modified eqn for MATLAB. e.g: x.^2 + y.^2

      % For multiplication
      modEqn = strrep(eqn, '*', '.*');

      % For division
      modEqn = strrep(modEqn, '/', './');

      % For power
      modEqn = strrep(modEqn, '^', '.^');
    end

    % Main function
    function main()
      curGraphType = coordTypeCellArray{curGraphTypeIndx};
      setRange();

      % Ranges
      r1 = [str2double(minRange1), str2double(maxRange1)];
      r2 = [str2double(minRange2), str2double(maxRange2)];

      % Control flow of Rectangular plot
      if strcmpi(curGraphType, 'rectangular')
        if strcmpi(eqnInput.String, '')
          eqnInput.String = 'x^2 + y^2';
        end

        eqn = elemWiseEqn(eqnInput.String);

        % Main equation
        F = str2func(strcat('@(x, y)', eqn));
        [X, Y, Z] = points('r', F, r1, r2);
        plotting_graph(X, Y, Z);
        return;
      end

      % Control flow of Cylindrical plot
      if strcmpi(curGraphType, 'cylindrical')
        if strcmpi(eqnInput.String, '')
          eqnInput.String = 'sqrt(r^2 + 1)';
        end

        eqn = elemWiseEqn(eqnInput.String);

        F = str2func(strcat('@(r, th)', eqn));
        [X, Y, Z] = points('c', F, r1, r2);
        plotting_graph(X, Y, Z);
        return;
      end

      % spherical
      if strcmpi(curGraphType, 'spherical')
        if strcmpi(eqnInput.String, '')
          eqnInput.String = '5';
        end

        eqn = elemWiseEqn(eqnInput.String);

        F = str2func(strcat('@(th, phi)', eqn));
        [X, Y, Z] = points('s', F, r1, r2);
        plotting_graph(X, Y, Z);
        return;
      end
    end

    % Calling main function to bootstrap the plotting
    main();
  end
end

