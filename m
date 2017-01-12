From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: TPM 2.0 RM getcapability #1
Date: Thu, 12 Jan 2017 09:56:14 -0500
Message-ID: <o585e6$cb0$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Question 1 of 2:

The RM is virtualizing transient handles.  When getcapability returns 
TPM handles, they have to be mapped to the virtual handles.

Where should the mapping occur?  RM vs. user space TSS?

- The RM sees the TPM physical handles, and knows the mapping to virtual 
handles for that process.  It can do accurate mapping.

However, it adds complexity to the kernel driver.  Kernel complexity is 
to be avoided, and bugs are harder to fix than in the user space TSS.

- The user space TSS would have to track the transient handles for the 
process.  In this case, the TSS would not even send the getcapability 
command, but just emulate it in the library.

However, this is a local calculation of what SHOULD be in the RM, and 
does not consider bugs in either code.

~~

I don't have a strong feeling either way.

However, I'd like to know the sense of the community.  As a TSS 
maintainer, I want to know if I should start writing code.


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
