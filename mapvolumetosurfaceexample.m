% change to data directory
cd /stone/ext1/fmridata/20160212-ST001-E002/

% get the volume that we want to map
vol = load_untouch_nii('preprocess/mean.nii');
vol = double(vol.img);

% load in the alignment information
a1 = load('freesurferalignment/alignment.mat');

% define FreeSurfer stuff
fsdir = '/home/stone/software/freesurfer/subjects/C1051';
subjectid = 'C1051';

% define
hemis = {'lh' 'rh'};
interptype = 'linear';  % what type of interpolation?
outputname = 'data';    % use this in the output filename

%%%%%%%%%%%%%%%%%%%%%%%%%%

% load surfaces
vertices = {};
for p=1:length(hemis)
  vertices{p} = freesurfer_read_surf_kj(sprintf('%s/surf/%s.graymid',fsdir,hemis{p}));
  vertices{p} = bsxfun(@plus,vertices{p}',[128; 129; 128]);  % NOTICE THIS!!!
  vertices{p}(4,:) = 1;  % now: 4 x V
end

% map volume onto surfaces
for p=1:length(hemis)
  
  % get coordinates of the surfaces in volume space
  coord = volumetoslices(vertices{p},a1.tr);
  coord = coord(1:3,:);
  
  % perform interpolation to map the volume values onto the surfaces
  vals = ba_interp3_wrapper(vol,coord,interptype);
  
  % write out the .mgz file to [lh,rh].<outputname>.mgz
  cvnwritemgz(subjectid,outputname,vals,hemis{p},'/home/stone/kendrick/');

end
