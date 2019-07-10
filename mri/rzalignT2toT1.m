function rzalignT2toT1(t1nifti, t2nifti,outputdir,imgoutputdir)
%
% the matlab wrapper to alignT2toT1 using FSL utility function. This is the
% same as cvnalignT2toT1. But we avoid many cvnlab specific jargon
%
% Input:
%   T1nifti: a string, the full path name of the reference T1 nifti file.
%   T2nifti: a string, the full path name of the T2 nifti file you want to
%       align
%   outputdir: the folder path to save the T2alignedtoT1.nii.gz
%   imgoutputdir: the path to save the images and the transformation matrix
%   

t2tot1nifti = sprintf('%s/T2alignedtoT1.nii.gz', outputdir);
extrastr = '-cost mutualinfo -searchcost mutualinfo'; % we default use mutual informatio to align them
assert(0==unix(sprintf('flirt -in %s -ref %s -out %s -interp sinc -dof 6 %s',t2nifti,t1nifti,t2tot1nifti,extrastr)));

% inspect the results
makeimagestack3dfiles(t1nifti,    sprintf('%s/T1T2alignment/T1',imgoutputdir),[5 5 5],[-1 1 0],[],1);
makeimagestack3dfiles(t2tot1nifti,sprintf('%s/T1T2alignment/T2',imgoutputdir),[5 5 5],[-1 1 0],[],1);

end 