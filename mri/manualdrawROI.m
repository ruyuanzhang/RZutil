R=[];
%% Interactive drawing process begins here!
% press Escape to erase and start again
% double click on final vertex to close polygon
% right click on first vertex, and click "Create mask" to view the result
% Keep going until user closes the window

while(ishandle(h))
    [r,rx,ry]=roipoly();
    if(isempty(r))
        continue;
    end
    R=spherelookup_image2vert(r,L)>0;
    
    imgroi=spherelookup_vert2image(R,L,0);
    
    %quick way to merge rgbimg background with roi mask
    tmprgb=bsxfun(@times,rgbimg,.75*imgroi + .25);
    set(h,'cdata',tmprgb); 
end

%% view final result
[img2,~,rgbimg]=cvnlookupimages(subject,zeros(size(R)),hemi,[],L,...
    'cmap','gray','clim',[0 1],'alpha',0,...
    'background',ang,'bg_clim',[0 360],'bg_cmap','jet',...
    'text',upper(hemi),...
    'roimask',R);
figure;
imshow(rgbimg);

%% now save the label file
roiidx=find(roival>0);
if(isequal(labelsuffix,'orig'))
    labelsuffix='';
end
labelfile=sprintf('%s/%s/label/%s%s.%s.label',cvnpath('freesurfer'),subject,hemi,displaysuffix,labelname);
write_label(roiidx-1,zeros(numel(roiidx),3),ones(numel(roiidx),1),labelfile,subject,'TkReg');