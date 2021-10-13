function plotCoorLegend_rev(group)

% plots legend for coordination figures (Figure 5)

scX = 62;   % default x coordinate
txtSz = 10;

% set colors
if group == 1
    l1 = [173/255 239/255 201/255]; 
    l2 = [116/255 226/255 163/255]; 
    l3 = [62/255 215/255 128/255];
    l4 = [26/255 182/255 94/255];
    l5 = [11/255 129/255 62/255];
else
    l1 = [255/255 153/255 204/255]; 
    l2 = [255/255 102/255 178/255]; 
    l3 = [255/255 51/255 153/255];
    l4 = [255/255 0/255 172/255];
    l5 = [204/255 0/255 102/255];
end

% create legend, draw lines
line([scX scX],[15.8 14.5],'Color',l1,'LineWidth',2)
line([scX scX],[14.5 13.2],'Color',l2,'LineWidth',2)
line([scX scX],[13.2 11.9],'Color',l3,'LineWidth',2)
line([scX scX],[11.9 10.6],'Color',l4,'LineWidth',2)
line([scX scX],[10.6 9.3],'Color',l5,'LineWidth',2)

% add text labels
text(scX+5,15.2,'S1-2','FontSize',txtSz)
text(scX+5,13.9,'S3-4','FontSize',txtSz)
text(scX+5,12.6,'S5-6','FontSize',txtSz)
text(scX+5,11.3,'S7-8','FontSize',txtSz)
text(scX+5,10,'S9-10','FontSize',txtSz)
