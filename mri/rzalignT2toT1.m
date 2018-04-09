function rzalignT2toT1(t1nifti, t2nifti, t2tot1nifti,outputfilepath)
%
% the matlab wrapper to alignT2toT1 using FSL utility function. This is the
% same as cvnalignT2toT1. But we avoid many cvnlab specific jargon
%
% Input:
%   T1nifti: a string, the full path name of the reference T1 nifti file.
%   T2nifti: a string, the full path name of the T2 nifti file you want to
%       align
%   T2aligntoT1nifti: a string the full path name of the output T2 nifti file 
%       after the alignment.
%   outputfilepath: the folder path to save the alignment results.
%   

extrastr = '-cost mutualinfo -searchcost mutualinfo'; % we default use mutual informatio to align them
assert(0==unix(sprintf('flirt -in %s -ref %s -out %s -interp sinc -dof 6 %s',t2nifti,t1nifti,t2tot1nifti,extrastr)));

% inspect the results
makeimagestack3dfiles(t1nifti,    sprintf('%s/T1T2alignment/T1',outputfilepath),[5 5 5],[-1 1 0],[],1);
makeimagestack3dfiles(t2tot1nifti,sprintf('%s/T1T2alignment/T2',outputfilepath),[5 5 5],[-1 1 0],[],1);

end 